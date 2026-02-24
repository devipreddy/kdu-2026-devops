variable "project_name" { type = string }
variable "environment" { type = string }

variable "vpc_id" {
  type = string
}

# CIDR blocks allowed to SSH into the bastion (your public IP / office CIDR)
variable "bastion_ingress_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to SSH to bastion (e.g. [\"1.2.3.4/32\"])"
}