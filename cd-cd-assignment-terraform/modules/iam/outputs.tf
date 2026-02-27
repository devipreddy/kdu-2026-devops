output "codebuild_role_arn" {
  value = aws_iam_role.codebuild_role.arn
}

output "eb_service_role_name" {
  value = aws_iam_role.eb_service_role.name
}

output "eb_instance_profile_name" {
  value = aws_iam_instance_profile.eb_ec2_instance_profile.name
}