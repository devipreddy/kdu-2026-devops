output "codebuild_role_arn" {
  value = module.iam.codebuild_role_arn
}

# output "eb_service_role_arn" {
#   value = module.iam.eb_service_role_arn
# }

output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "codebuild_project_name" {
  value = module.codebuild.codebuild_project_name
}

output "elasticbeanstalk_application_name" {
  value = module.elasticbeanstalk.application_name
}

output "elasticbeanstalk_environment_name" {
  value = module.elasticbeanstalk.environment_name
}

output "elasticbeanstalk_environment_url" {
  value = module.elasticbeanstalk.environment_url
}