

data "aws_elastic_beanstalk_solution_stack" "java" {
  most_recent = true
  name_regex  = "64bit Amazon Linux 2023.*running Corretto 21"
}


resource "aws_elastic_beanstalk_application" "app" {
  name        = "${var.project_name}-app"
  description = "Spring Boot CI/CD Application"
}


resource "aws_elastic_beanstalk_environment" "env" {
  name                = "${var.project_name}-${var.environment}"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.java.name

 

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }



  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }


  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.instance_profile_name
  }


  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.service_role_name
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "Rolling"
  }

  wait_for_ready_timeout = "20m"
}