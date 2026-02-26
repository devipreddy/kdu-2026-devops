variable "project_name" { type = string }
variable "environment"  { type = string }

variable "vpc_id"        { type = string }
variable "db_subnet_ids" { type = list(string) }
variable "db_sg_id"      { type = string }

variable "db_name"     { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string }

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "engine_version" {
  type    = string
  default = null
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}