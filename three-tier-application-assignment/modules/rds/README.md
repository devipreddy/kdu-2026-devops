RDS Module

Purpose

Creates a subnet group and a MySQL RDS instance in the isolated database subnets.

Resources created

- `aws_db_subnet_group`
- `aws_db_instance` (MySQL)

Key variables (inputs)

- `db_subnet_ids`
- `db_instance_class` (e.g., db.t3.micro)
- `db_name`, `username`, `password` (prefer storing in Secrets Manager)
- `db_allocated_storage`

Outputs

- `db_endpoint`
- `db_identifier`

Notes

- `publicly_accessible` is `false` for security.
- Consider using Secrets Manager + KMS for credentials; avoid hardcoding passwords in tfvars.
- This module is intended to be used with the `security` module to restrict access to the DB security group.
