environment = "dev"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]
private_app_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]
db_subnet_cidrs = [
  "10.0.21.0/24",
  "10.0.22.0/24"
]

bastion_ingress_cidrs = ["122.166.215.122/32"]

aws_region = "ap-south-1"

key_name = "devi-kdu-assignment2-key"

repo_branch       = "main"
frontend_repo_url = "https://github.com/Sathwikkd1/kdu-frontend-app.git"
backend1_repo_url = "https://github.com/Sathwikkd1/kdu-backend-app-1.git"
backend2_repo_url = "https://github.com/Sathwikkd1/kdu-backend-app-2.git"

# TEMP until we create RDS module:
db_host     = "example.rds.amazonaws.com"
db_name     = "company"
db_username     = "admin"
db_password = "devi123!"