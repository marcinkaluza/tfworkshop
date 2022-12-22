output s3_bucket_name {
   value = aws_s3_bucket.bucket.bucket
   description = "Name of the S3 bucket"
}

output lock_table_name {
   value = aws_dynamodb_table.locks.name
   description = "Name of the dynamodb table for terraform state"
}