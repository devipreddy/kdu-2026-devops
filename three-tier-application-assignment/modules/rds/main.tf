locals {
  name_prefix = "devi-${var.project_name}-${var.environment}"
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name        = "${local.name_prefix}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "this" {
  identifier = "${local.name_prefix}-db"

  engine         = "mysql"
  engine_version = var.engine_version

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_sg_id]

  multi_az            = var.multi_az
  publicly_accessible = var.publicly_accessible

  backup_retention_period = 1
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = false

  apply_immediately = true

  tags = {
    Name        = "${local.name_prefix}-db"
    Environment = var.environment
  }
}