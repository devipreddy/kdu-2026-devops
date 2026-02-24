
## Three‑Tier Infrastructure — Root Terraform

Demo Video Link: https://drive.google.com/file/d/1BJ2g1-cUJQs-M9vkGuX8Epb1-tEJGX5O/view?usp=sharing

Design goals and assumptions

- Reusability: modules are parameterized and may be instantiated in multiple environments (dev/prod).
- Safety: remote state stored in an S3 backend with DynamoDB locking to prevent concurrent state corruption.
- Least privilege: IAM roles and instance profiles are scoped to minimal required permissions; secrets are handled via Secrets Manager when possible.
- Cost-awareness: example instance sizes and a single NAT gateway are chosen to limit cost during testing; production recommendations are noted where higher availability is expected.

Repository structure and important files

- **backend.tf**: S3 backend configuration (bucket, key, region) and DynamoDB locking table reference. This file determines where Terraform stores state and thereby controls collaboration semantics.
- **variables.tf**: root-level variables that are passed into modules (region, project_name, environment, CIDR blocks, etc.).
- **dev.tfvars**, **prod.tfvars**: environment-specific variable files. These supply environment, CIDRs, allowed IP ranges, and non-secret defaults for quick provisioning.
- **modules/**: a directory containing the modular building blocks:
	- `vpc/` — VPC, subnets, IGW, NAT gateway, routing
	- `security/` — security groups for ALB, application, database, bastion
	- `compute/` — bastion, EC2 launch template, ASG, key pair handling
	- `alb/` — Application Load Balancer, listeners, target groups, listener rules
	- `rds/` — DB subnet group and RDS MySQL instance
- **outputs.tf**: top-level outputs exposing important identifiers (ALB DNS, DB endpoint, VPC ID) for operators and automation.

High-level deployment flow (conceptual)

1. Configure remote backend (S3 + DynamoDB) to ensure state is versioned and locked during changes.
2. Provide the appropriate `*.tfvars` file for the target environment (dev/prod) and verify sensitive values are supplied via Secrets Manager or CI secrets.
3. Run `terraform init` to initialize the working directory and configure the backend provider.
4. Run `terraform plan -var-file=ENV.tfvars` to verify changes.
5. Run `terraform apply -var-file=ENV.tfvars` to provision resources.

Example commands

```bash
cd infra
terraform init
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

Detailed component descriptions and rationale

**Network (VPC module)**

The VPC module establishes the network topology that enforces tier isolation and enables secure routing:

- A single VPC (e.g., `10.0.0.0/16`) provides address space.
- Public subnets host externally reachable components (ALB, bastion). These subnets have auto-assign public IP enabled and a route to the Internet Gateway. Public subnets are placed in at least two AZs to allow ALB high availability.
- Private application subnets host the application Auto Scaling Group instances. They are not directly reachable from the Internet; outbound access for updates and package downloads is provided via a NAT gateway.
- Isolated database subnets host RDS instances and do not have routes to the internet (no NAT or IGW routes). This minimizes exposure and reduces blast radius.

Rationale: segmenting the network reduces attack surface, supports least-privilege networking policies, and enables different security group rules per tier.

**Security (security module)**

Security groups implement application-level network access control:

- ALB SG: allows inbound HTTP/HTTPS from 0.0.0.0/0 and all outbound.
- Application SG: allows inbound HTTP from ALB SG and SSH from the bastion SG. Outbound is unrestricted to allow connections to the DB and other AWS services.
- DB SG: restricts inbound MySQL to the application SG only; no public inbound allowed.
- Bastion SG: SSH from operator IP ranges only.

Rationale: using SG references (security group as source) rather than IP ranges for internal communication is more maintainable and less error-prone.

**Compute (compute module)**

This module handles compute provisioning with cost-conscious defaults for development:

- A bastion host (t3.micro) in a public subnet for administrative access.
- An EC2 Launch Template used by an Auto Scaling Group for the application tier. The launch template provides user-data bootstrapping which pulls the application images and starts them (Docker, Node, or other runtime).
- ASG configured with min=1, desired=1, max=2 for graceful scaling in tests.

Bootstrapping/user-data: the included `user_data.sh.tftpl` is templated with repository URLs and DB connection settings. In production, prefer passing secrets via SSM Parameter Store or Secrets Manager.

**Load Balancing (alb module)**

An Application Load Balancer serves as the public entry point and routes requests to application target groups:

- HTTP listener on port 80 redirects to HTTPS (301).
- HTTPS listener on port 443 with a default fixed response (404) and explicit path-based listener rules that route API endpoints to backend target groups and all other traffic to the frontend target group.

Health checks are configured to ensure only healthy instances receive traffic (path: `/health`, interval: 30s, timeout: 5s).

**Database (rds module)**

RDS MySQL is provisioned inside an RDS subnet group which spans multiple AZs for failover. The instance is configured with security group restrictions and is not publicly accessible.

Operational considerations and state management

Remote backend

- Use S3 for backend state: enable bucket versioning and server-side encryption (SSE-KMS preferred).
- Use a DynamoDB table for state locking to prevent concurrent modifications.

Secrets and credentials

- Do not commit secrets to `*.tfvars` files in the repository.
- Use AWS Secrets Manager or SSM Parameter Store for database credentials and any tokens. Reference secrets at runtime or fetch them in bootstrap scripts.

Environments and naming conventions

All modules use a `local.name_prefix` constructed as `devi-${var.project_name}-${var.environment}` which ensures resource names are globally unique and convey environment intent. Avoid double-prefixing (do not prepend `devi-` again where `local.name_prefix` is used).

Module inputs and outputs (mapping)

Each module exposes a small set of inputs and outputs. At the root, populate these by reading the module `variables.tf` and `outputs.tf`. Examples:

- VPC module inputs: `vpc_cidr`, `public_subnet_cidrs`, `private_app_subnet_cidrs`, `db_subnet_cidrs`, `azs`.
- VPC outputs: `vpc_id`, `public_subnet_ids`, `private_app_subnet_ids`, `db_subnet_ids`.
- Security inputs: `vpc_id`, `bastion_ingress_cidrs`.
- Compute inputs: `private_app_subnet_ids`, `app_sg_id`, `bastion_sg_id`, `key_name`, `repo_*` variables.

Testing and verification

After `terraform apply`, verify the following:

- ALB is provisioned and DNS resolves (check `aws elbv2 describe-load-balancers`).
- ASG has at least one healthy instance and the target group health checks succeed.
- RDS endpoint is reachable from an application instance (use the bastion to run a connectivity test; do not open RDS to the public internet).

Example verification commands (from your workstation with AWS CLI configured):

```bash
# List ALBs
aws elbv2 describe-load-balancers --region <region>

# Describe target group health
aws elbv2 describe-target-health --target-group-arn <tg-arn> --region <region>

# Test RDS connectivity (from bastion via SSH)
# On bastion: mysql -h <db-endpoint> -u <user> -p
```

Security and compliance considerations

- Ensure S3 backend complies with your organization’s encryption and retention policies.
- Enable logging (VPC Flow Logs, ALB access logs) for production auditing.
- Rotate keys and credentials regularly; prefer IAM roles for services over long-lived access keys.

Cost considerations

- Single NAT Gateway reduces cost but is a single point of failure; for production deploy NAT gateways per AZ.
- The example uses t3.micro and db.t3.micro to minimize cost during development.

Troubleshooting

- If Terraform cannot acquire the lock: check the DynamoDB table and remove stale locks only after verifying no active operations.
- If `terraform init` fails due to backend changes: inspect `backend.tf` and ensure the S3 bucket exists and you have permission to access it.


Appendix — Recommended step-by-step for a new environment

1. Create or configure the S3 backend bucket and DynamoDB lock table with versioning and encryption.
2. Copy `dev.tfvars` to `environments/dev.tfvars` and update non-secret values.
3. Store secrets in AWS Secrets Manager and pass ARN values to Terraform via environment variables or SSM parameters.
4. Run `terraform init` and `terraform plan -var-file=environments/dev.tfvars`.
5. After validating the plan, `terraform apply -var-file=environments/dev.tfvars`.

For the module-level documentation, see the module README files in `modules/` which provide variable and output mappings and usage examples.


