############################################
# Get Latest Corretto 21 Solution Stack
############################################

data "aws_elastic_beanstalk_solution_stack" "java" {
  most_recent = true
  name_regex  = "64bit Amazon Linux 2023.*running Corretto 21"
}

############################################
# Elastic Beanstalk Application
############################################

resource "aws_elastic_beanstalk_application" "app" {
  name        = "${var.project_name}-app"
  description = "Spring Boot CI/CD Application"
}

############################################
# Elastic Beanstalk Environment
############################################

resource "aws_elastic_beanstalk_environment" "env" {
  name                = "${var.project_name}-${var.environment}"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.java.name

  ##########################################
  # Environment Type
  ##########################################

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  ##########################################
  # Instance Type
  ##########################################

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  ##########################################
  # Attach EC2 Instance Profile
  ##########################################

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.instance_profile_name
  }

  ##########################################
  # Attach Service Role
  ##########################################

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.service_role_name
  }

  ##########################################
  # Health Monitoring
  ##########################################

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  ##########################################
  # Rolling Deployment
  ##########################################

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "Rolling"
  }

  wait_for_ready_timeout = "20m"
}