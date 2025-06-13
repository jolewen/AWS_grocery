
resource "aws_s3_bucket" "avatars" {
  bucket = "grocerymate_avatars"

  tags = {
    Name        = "grocerymate-avatars"
    Environment = "Dev"
  }
}