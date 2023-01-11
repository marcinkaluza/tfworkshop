#
# Create outputs containing name of the S3 bucket created and 
# name of the dynamo db table

# Refer to Attributes Reference section of the documentation :
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
#
output "bucket" {
  value       = aws_s3_bucket.bucket.bucket
  description = "Name of the S3 bucket"
}

output "dynamodb_table" {
  value       = aws_dynamodb_table.locks.name
  description = "Name of the dynamodb table for terraform state"
}