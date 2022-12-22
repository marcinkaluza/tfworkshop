#
# S3 Bucket for terraform state storage
#
resource aws_s3_bucket bucket{
  bucket_prefix = "tf-state-"
}

#
# Dynamodb table for terraofrm lock
#
resource "aws_dynamodb_table" "locks" {
  name           = "terraform-state-lock"
  hash_key       = "LockID"
  read_capacity  = 2
  write_capacity = 2

  attribute {
    name = "LockID"
    type = "S"
  }
}