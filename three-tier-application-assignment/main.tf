data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr = var.vpc_cidr
  azs      = local.azs

  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  db_subnet_cidrs          = var.db_subnet_cidrs

  single_nat_gateway = var.single_nat_gateway
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id

  bastion_ingress_cidrs = var.bastion_ingress_cidrs
}

module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment

  vpc_id        = module.vpc.vpc_id
  db_subnet_ids = module.vpc.db_subnet_ids
  db_sg_id      = module.security.db_sg_id

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}


module "compute" {
  source = "./modules/compute"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id

  # Bastion in first public subnet
  public_subnet_id = module.vpc.public_subnet_ids[0]

  # ASG in private app subnets
  private_app_subnet_ids = module.vpc.private_app_subnet_ids

  bastion_sg_id = module.security.bastion_sg_id
  app_sg_id     = module.security.app_sg_id

  # SSH keypair (from your machine)
  key_name        = var.key_name
  generate_keypair        = true
  private_key_output_path = "generated_keys/kdu_assignment2.pem"

  # GitHub repos / branch
  repo_branch       = var.repo_branch
  frontend_repo_url = var.frontend_repo_url
  backend1_repo_url = var.backend1_repo_url
  backend2_repo_url = var.backend2_repo_url

  # DB vars (temporary; later we will pass from RDS module outputs)
db_host     = module.rds.endpoint
db_name     = module.rds.db_name
db_username = module.rds.username
db_password = var.db_password

  # ASG sizing
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
}

module "alb" {
  source = "./modules/alb"

  project_name = var.project_name
  environment  = var.environment

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  alb_sg_id          = module.security.alb_sg_id

  asg_name = module.compute.asg_name

  health_check_path = "/health"
}

