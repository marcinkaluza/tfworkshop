terraform {
  required_version = ">= 1.0"
  required_providers {
    aws        = ">= 4.45"
    kubernetes = "2.16.1"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project       = "A project"
      "Cost centre" = "Accounting"
    }
  }
}

variable "bucket_prefix" {
  type        = string
  description = "Prefix of the S3 Bucket name"
  default     = "my-bucket"
}

resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "my-${var.bucket_prefix}-bucket-"
  policy = file(“${path.module}/config.json”)

}

output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}

