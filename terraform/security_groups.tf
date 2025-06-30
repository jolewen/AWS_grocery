resource "aws_security_group" "webstore-sg" {
  name        = "webstore_sg"
  description = "SG for EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol  = "tcp"
    from_port = 5001
    to_port   = 5001
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds-sg" {
  name        = "rds_sg"
  description = "SG for RDS, allowing only EC2 SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.webstore-sg.id]
    description = "PostgreSQL from EC2"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}