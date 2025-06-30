resource "aws_db_instance" "postgres" {
  identifier          = var.db_identifier
  engine              = "postgres"
  engine_version      = "15.13"
  instance_class      = var.db_instance_class
  allocated_storage   = 20
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  publicly_accessible = false
  snapshot_identifier = "grocerymate-pg"
  skip_final_snapshot = true
  delete_automated_backups = true

  # Networking
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  db_subnet_group_name = var.db_subnet_group
  multi_az             = false
  storage_encrypted    = true
}