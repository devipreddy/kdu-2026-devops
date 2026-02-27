

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
  environment  = var.environment
}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
  environment  = var.environment
}

module "elasticbeanstalk" {
  source                = "./modules/elasticbeanstalk"
  project_name          = var.project_name
  environment           = var.environment
  instance_type         = "t3.micro"

  service_role_name     = module.iam.eb_service_role_name
  instance_profile_name = module.iam.eb_instance_profile_name
}



module "codebuild" {
  source           = "./modules/codebuild"
  project_name     = var.project_name
  environment      = var.environment
  github_repo_url  = var.github_repo_url
  branch_name      = var.branch_name
  service_role_arn = module.iam.codebuild_role_arn
  artifact_bucket  = module.s3.bucket_name
}