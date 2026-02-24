variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type = string
}

variable "creator" {
  type    = string
  default = "Devi Prasad"
}

variable "purpose" {
  type    = string
  default = "Assignment-2 Three-Tier Architecture"
}

variable "project_name" {
  type    = string
  default = "modern-3-tier"
}

variable "vpc_cidr" {
  type = string
}

variable "az_count" {
  type    = number
  default = 2
}
variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_app_subnet_cidrs" {
  type = list(string)
}

variable "db_subnet_cidrs" {
  type = list(string)
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

variable "bastion_ingress_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to SSH to bastion"
}

variable "key_name" { type = string }

variable "repo_branch" { type = string }
variable "frontend_repo_url" { type = string }
variable "backend1_repo_url" { type = string }
variable "backend2_repo_url" { type = string }

variable "db_host" { type = string }
# variable "db_name" { type = string }
# variable "db_user" { type = string }
# # variable "db_password" { type = string }

variable "min_size" {
  type    = number
  default = 1
}
variable "max_size" {
  type    = number
  default = 2
}
variable "desired_capacity" {
  type    = number
  default = 1
}

variable "db_name" {
  type        = string
  description = "Database name for the application"
}

variable "db_username" {
  type        = string
  description = "Master username for the database"
}

variable "db_password" {
  type        = string
  description = "Master password for the database"
  sensitive   = true
}