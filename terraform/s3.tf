
resource "aws_s3_bucket" "avatars" {
  bucket = "grocerymate-avatars-jle"

  tags = {
    Name        = "grocerymate-avatars"
    Environment = "Dev"
  }
}