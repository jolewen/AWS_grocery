### --------- key pair creation for EC2 --------- ###
resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "private_key_pem" {
  value     = tls_private_key.ec2_key.private_key_pem
  sensitive = true
}

output "public_key_openssh" {
  value = tls_private_key.ec2_key.public_key_openssh
}

### --------- IAM role for EC2 --------- ###
# Role policy definition
data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Role definition and policy assignment
resource "aws_iam_role" "ec2_instance_role" {
  name               = "ec2-rds-s3-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}

# Permissions - here full access to rds and s3
data "aws_iam_policy_document" "ec2_rds_s3_full_access" {
  statement {
    effect = "Allow"

    actions = [
      "s3:*",
      "rds:*"
    ]

    resources = ["*"]
  }
}

# Assign permissions to role
resource "aws_iam_role_policy" "full_access_policy" {
  name   = "ec2-rds-s3-full-access"
  role   = aws_iam_role.ec2_instance_role.id
  policy = data.aws_iam_policy_document.ec2_rds_s3_full_access.json
}

# Create profile for EC2 to assume
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}


### --------- EC2 definition --------- ###
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "webserver" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type
  key_name = aws_key_pair.ec2_key.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.webstore_sg.id]

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y && \
  sudo yum install -y git postgresql15
  EOF

  tags = {
    Name = "ec2-with-full-rds-s3-access"
  }
}
