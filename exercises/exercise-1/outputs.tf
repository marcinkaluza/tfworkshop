output s3_bucket_name {
   value = aws_s3_bucket.bucket.bucket
   description = "Name of the S3 bucket"
}

# Refer to Attributes Reference section of the documentation :
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
#
output lock_table_name {

}