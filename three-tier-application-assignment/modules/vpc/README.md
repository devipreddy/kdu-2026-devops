VPC Module

Purpose

Creates the VPC and networking primitives required for the three-tier architecture: public subnets (for ALB and bastion), private application subnets, and isolated database subnets.

Resources created

- aws_vpc
- aws_internet_gateway
- aws_subnet (public, private_app, db)
- aws_eip, aws_nat_gateway
- aws_route_table, aws_route_table_association

Key variables (inputs)

- `vpc_cidr` - VPC CIDR block
- `public_subnet_cidrs` - List of public subnet CIDRs
- `private_app_subnet_cidrs` - List of private app subnet CIDRs
- `db_subnet_cidrs` - List of DB subnet CIDRs
- `azs` - Availability zones list

Outputs

- `vpc_id`
- `public_subnet_ids`
- `private_app_subnet_ids`
- `db_subnet_ids`

Naming

This module uses `local.name_prefix` which includes the `devi-` prefix. Tags and resource names use `${local.name_prefix}-<resource>`.

Usage

Call this module from the root `infra/` module and pass subnet CIDRs and AZs. Use outputs when wiring other modules (security groups, ALB, ASG, RDS).
