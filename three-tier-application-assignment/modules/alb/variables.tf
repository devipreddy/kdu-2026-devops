variable "project_name" { type = string }
variable "environment"  { type = string }

variable "vpc_id" { type = string }

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets for ALB"
}

variable "alb_sg_id" {
  type        = string
  description = "Security group ID for ALB"
}

# ASG name to attach to target group
variable "asg_name" {
  type        = string
  description = "Auto Scaling Group name for app instances"
}

variable "health_check_path" {
  type    = string
  default = "/health"
}