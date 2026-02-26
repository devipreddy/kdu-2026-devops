Compute Module

Purpose

Provides compute resources: an SSH bastion host in a public subnet, EC2 launch template for application instances, and an Auto Scaling Group distributing instances across private application subnets.

Resources created

- `aws_key_pair` (public key stored in AWS)
- `tls_private_key` (private key output path configurable)
- `aws_instance` bastion
- `aws_launch_template` for app servers
- `aws_autoscaling_group` with scaling policies

Key variables (inputs)

- `private_key_output_path`
- `instance_type`, `ami` (via data sources)
- `private_app_subnet_ids`
- `app_sg_id`, `bastion_sg_id`
- `repo` and `user_data` params used to bootstrap apps

Outputs

- `bastion_public_ip`
- `asg_name`
- `instance_profile_name`

User data

The launch template uses a `user_data` script (see `user_data.sh.tftpl`) to install Docker/Node/etc and run the provided frontend/backend images. Ensure DB credentials are passed securely via variables or a secrets manager.

Scaling

ASG default: min=1, max=2, desired=1. Policies scale based on CPU; cooldowns set to 300s.
