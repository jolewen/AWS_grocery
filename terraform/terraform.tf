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

resource "aws_instance" "webserver" {
  instance_type = "t2.micro"
  key_name = "webserver-private-pair"
  launch_template { 
  id = "lt-0568aae9bc6372ad5"
  version = "$Latest"
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = var.db_identifier
  engine                  = "postgres"
  engine_version          = "15.4"
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  publicly_accessible     = false
  skip_final_snapshot     = true
  delete_automated_backups = true

  vpc_security_group_ids  = [var.db_security_group_id]
  db_subnet_group_name    = var.db_subnet_group
  multi_az                = false
  storage_encrypted       = false
}

output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}