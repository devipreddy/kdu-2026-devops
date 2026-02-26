data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "devi-docker-assignment-ec2-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change to your IP for better security
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "rds_sg" {
  name   = "devi-docker-assignment-rds-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_subnet_group" "default" {
  name       = "devi-docker-assignment-db-subnet"
  subnet_ids = data.aws_subnets.default.ids
}

resource "aws_db_instance" "mysql" {
  identifier              = "devi-docker-assignment-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = var.db_username
  password                = var.db_password
  db_name                 = "currency"
  publicly_accessible     = false
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.default.name
}


locals {
  docker_compose = templatefile("${path.module}/docker-compose.yml.tmpl", {
    rds_endpoint = aws_db_instance.mysql.address
    db_username  = var.db_username
    db_password  = var.db_password
  })
}
resource "aws_key_pair" "devi_key" {
  key_name   = "devi-docker-assignment-key"
  public_key = file("${path.module}/devi-docker-assignment-key.pub")
}

resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.devi_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = templatefile("${path.module}/user-script.sh.tmpl", {
    docker_compose = local.docker_compose
  })

  tags = {
    Name = "devi-docker-assignment-ec2"
  }

  depends_on = [aws_db_instance.mysql]
}