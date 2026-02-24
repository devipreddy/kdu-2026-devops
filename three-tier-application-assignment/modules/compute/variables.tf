variable "project_name" { type = string }
variable "environment" { type = string }

variable "vpc_id" { type = string }

variable "public_subnet_id" {
  type        = string
  description = "One public subnet for bastion"
}

variable "private_app_subnet_ids" {
  type        = list(string)
  description = "Private subnets for ASG instances"
}

variable "bastion_sg_id" { type = string }
variable "app_sg_id" { type = string }

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "generate_keypair" {
  type    = bool
  default = true
}

variable "private_key_output_path" {
  type        = string
  description = "Where to save the generated private key PEM (only used if generate_keypair=true)"
  default     = "generated_keys/app_key.pem"
}

variable "key_name" {
  type        = string
  description = "Name for the AWS key pair"
}

variable "repo_branch" {
  type    = string
  default = "main"
}

variable "frontend_repo_url" { type = string }
variable "backend1_repo_url" { type = string }
variable "backend2_repo_url" { type = string }

variable "frontend_port" {
  type    = number
  default = 80
}
variable "backend1_port" {
  type    = number
  default = 8080
}
variable "backend2_port" {
  type    = number
  default = 8081
}

variable "db_host" { type = string }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string }

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