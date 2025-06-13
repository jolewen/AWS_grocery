resource "aws_ssm_parameter" "pg_endpoint" {
  name        = "/dev/webstore/pghost"
  type        = "String"
  value       = aws_db_instance.postgres.endpoint
  lifecycle {
    ignore_changes = [value]
  }
}