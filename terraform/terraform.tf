terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.9"
    }
  }

  backend "s3" {
    bucket         = "terraform.bucket.jle"
    key            = "ec2/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "SG for EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["79.221.205.50/32", "0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = 5001
    to_port = 5001
    cidr_blocks = ["79.221.205.50/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg_2"
  description = "SG for RDS, allowing only EC2 SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
    description     = "PostgreSQL from EC2"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "webserver" {
  instance_type = "t2.micro"
  key_name = "webserver-private-pair"
  iam_instance_profile = "ec2-role-ssm"
  security_groups = ["ec2_sg"]
  launch_template {
  id = "lt-0568aae9bc6372ad5"
  version = "$Latest"
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = var.db_identifier
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  publicly_accessible     = false
  skip_final_snapshot     = true
  delete_automated_backups = true

  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = var.db_subnet_group
  multi_az                = false
  storage_encrypted       = false
}

output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

resource "aws_ssm_parameter" "pg_endpoint" {
  name        = "/dev/webstore/pghost"
  type        = "String"
  value       = aws_db_instance.postgres.endpoint
  lifecycle {
    ignore_changes = [value]
  }
}