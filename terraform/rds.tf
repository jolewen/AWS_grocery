resource "aws_db_instance" "postgres" {
  identifier              = var.db_identifier
  engine                  = "postgres"
  engine_version          = "15.13"
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  db_name                 = "postgres" #var.db_name
  username                = "postgres" #var.db_username
  password                = var.db_password
  publicly_accessible     = false
  # this demo should restore to the original state
  # that's why it uses a static snapshot for initialization
  # and skips storing any data updates
  snapshot_identifier     = "webstore-pg"
  skip_final_snapshot     = true
  delete_automated_backups = true

  # Networking
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = var.db_subnet_group
  multi_az                = false
  storage_encrypted       = true
}