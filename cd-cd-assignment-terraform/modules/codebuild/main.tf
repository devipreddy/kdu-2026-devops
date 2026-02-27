############################################
# CodeBuild Project
############################################

resource "aws_codebuild_project" "build" {
  name          = "${var.project_name}-${var.environment}-build"
  description   = "Spring Boot build for ${var.environment}"
  service_role  = var.service_role_arn
  build_timeout = 30

  ##########################################
  # Artifacts
  ##########################################

  artifacts {
    type      = "S3"
    location  = var.artifact_bucket
    packaging = "ZIP"
    path      = var.environment
    name      = "${var.project_name}.zip"
  }

  ##########################################
  # Environment
  ##########################################

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "ENV"
      value = var.environment
    }
  }

  ##########################################
  # Source (GitHub)
  ##########################################

  source {
    type            = "GITHUB"
    location        = var.github_repo_url
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  ##########################################
  # GitHub Webhook (optional for testing)
  ##########################################

  source_version = var.branch_name

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.project_name}-${var.environment}"
      stream_name = "build-log"
    }
  }
}