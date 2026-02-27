variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "service_role_name" {
  type = string
}

variable "instance_profile_name" {
  type = string
}