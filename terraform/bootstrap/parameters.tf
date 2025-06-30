locals {pghost=split(":", aws_db_instance.postgres.endpoint)[0]}

resource "aws_ssm_parameter" "pg_endpoint" {
  name  = "/dev/webstore/pghost"
  type  = "String"
  value = local.pghost
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "pg_db" {
  name  = "/dev/webstore/pgdb"
  type  = "String"
  value = var.db_name
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "pg_port" {
  name  = "/dev/webstore/pgport"
  type  = "String"
  value = 5432
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "pg_user" {
  name  = "/dev/webstore/pguser"
  type  = "String"
  value = var.db_username
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "pg_pwd" {
  name  = "/dev/webstore/pgpwd"
  type  = "SecureString"
  value = var.db_password
  lifecycle {
    ignore_changes = [value]
  }
}