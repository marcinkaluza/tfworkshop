locals {
  key_field = "LockID"
}
#
# Creates an S3 Bucket for terraform state storage, with auto-generated name starting with "tf-state-"
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
#
resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "tf-state-"
}


#
# Creates a Dynamodb table for terraform lock named "terraform-state-lock" with
# a read and write capacity of 2 units and hash key "LockID"
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
#
resource "aws_dynamodb_table" "locks" {
  name           = "tf-lock"
  write_capacity = 5
  read_capacity  = 5
  hash_key       = local.key_field

  attribute {
    name = local.key_field
    type = "S"
  }
}