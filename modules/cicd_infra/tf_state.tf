#
# S3 Bucket for terraform state storage
#
module "tf_bucket" {
  source      = "../s3_bucket"
  name_prefix = "tf-state-"
}

#
# Dynamodb table for terraofrm lock
#
resource "aws_dynamodb_table" "locks" {
  name           = "tf-state-lock"
  billing_mode   = "PROVISIONED"
  hash_key       = "LockID"
  read_capacity  = 2
  write_capacity = 2

  attribute {
    name = "LockID"
    type = "S"
  }
}