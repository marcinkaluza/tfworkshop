terraform {
  required_version = "~>1.3.6"
  required_providers {
    aws = ">= 4.45"
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "target_region" {
  type        = string
  default     = "us-east-1"
  description = "Target region"
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket_prefix = "photos-"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "local_file" "photo" {
  filename = "${path.module}/main.tf"
}

resource "aws_s3_object" "upload" {
  bucket  = module.s3_bucket.s3_bucket_id
  key     = "main.tf"
  content = data.local_file.photo.content
}

output "bucket_name" {
  value = module.s3_bucket.s3_bucket_id
}