terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.9"
    }
  }

  backend "s3" {
    bucket         = "terraform.bucket.jle"
    key            = "vpc/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-central-1"
  # No credentials here — picked up from GitHub OIDC env
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

output "vpc_id" {
  value = aws_vpc.example.id
}
