
resource "aws_s3_bucket" "avatars" {
  bucket = "grocerymate-avatars"

  tags = {
    Name        = "grocerymate-avatars"
    Environment = "Dev"
  }
}