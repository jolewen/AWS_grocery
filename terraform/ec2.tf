resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "ec2-role-ssm"
}

resource "aws_instance" "webserver" {
  instance_type = "t2.micro"
  key_name = "webserver-private-pair"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.webstore_sg.id]
  launch_template {
    id = "lt-0c7204c7a02b17cbe"
    version = "$Latest"
  }
}
