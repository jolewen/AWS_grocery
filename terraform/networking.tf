data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_subnets" "main" {
  ids = var.subnet_ids
}

data "aws_security_group" "default" {
  filter {
    name = "vpc-id"
    values = [var.vpc_id]
  }
}