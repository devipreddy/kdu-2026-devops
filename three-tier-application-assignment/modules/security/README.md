Security Module

Purpose

Defines security groups used across the three tiers: ALB, application servers, database, and bastion.

Security groups and rules

- ALB SG: Allow inbound HTTP (80) and HTTPS (443) from 0.0.0.0/0; all outbound.
- Application SG: Allow inbound HTTP (80) from ALB SG; inbound SSH (22) from Bastion SG; all outbound.
- DB SG: Allow inbound MySQL (3306) from Application SG only; deny other inbound.
- Bastion SG: Allow inbound SSH (22) from restricted IP ranges; all outbound.

Key variables (inputs)

- `vpc_id`
- `alb_sg_cidr` (optional)
- `bastion_allowed_cidrs`

Outputs

- `alb_sg_id`
- `app_sg_id`
- `db_sg_id`
- `bastion_sg_id`

Usage

Wire the `alb_sg_id` into the ALB module, `app_sg_id` into the compute module, and `db_sg_id` into the RDS module. Keep bastion access restricted to known IPs.
