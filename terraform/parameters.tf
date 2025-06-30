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