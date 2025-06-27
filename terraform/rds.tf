resource "aws_db_instance" "postgres" {
  identifier          = var.db_identifier
  engine              = "postgres"
  engine_version      = "15.13"
  instance_class      = var.db_instance_class
  allocated_storage   = 20
  db_name             = var.db_name
  username            = "postgres" # var.db_username
  password            = "postgres" # var.db_password
  publicly_accessible = false
  snapshot_identifier = "webstore-pg"
  skip_final_snapshot = true
  delete_automated_backups = true

  # Networking
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = var.db_subnet_group
  multi_az             = false
  storage_encrypted    = true
}