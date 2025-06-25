resource "aws_ssm_parameter" "pg_endpoint" {
  name  = "/dev/webstore/pghost"
  type  = "String"
  value = aws_db_instance.postgres.endpoint
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

resource "aws_ssm_parameter" "use_s3" {
  name  = "/dev/webstore/use_s3"
  type  = "String"
  value = "true"
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "s3_region" {
  name  = "/dev/webstore/s3_region"
  type  = "String"
  value = var.aws_region
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "s3_bucket_name" {
  name  = "/dev/webstore/s3_bucket_name"
  type  = "String"
  value = aws_s3_bucket.avatars.bucket
  lifecycle {
    ignore_changes = [value]
  }
}