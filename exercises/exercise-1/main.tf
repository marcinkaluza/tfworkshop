locals {
  # TODO: Add local variable holding the name of the key field. 
  # The value is case sensitive and should be "LockID"
}
#
# Creates an S3 Bucket for terraform state storage, with auto-generated name starting with "tf-state-"
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
#
resource "aws_s3_bucket" "bucket" {
  # TODO: Add required arguments:
  # bucket prefix
}


#
# Creates a Dynamodb table for terraform lock named "terraform-state-lock" with
# a read and write capacity of 2 units and hash key "LockID"
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
#
resource "aws_dynamodb_table" "locks" {
  # TODO: Add required arguments:
  # name
  # write capacity
  # read capacity
  # hash key - use local variable

  # TODO: replace hardcoded value with reference to local variable
  attribute {
    name = "LockID"
    type = "S"
  }
}