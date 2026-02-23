variable "project_name" {
  description = "Project name prefix for all resources"
  type        = string
  default     = "devi-serverless-app"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}