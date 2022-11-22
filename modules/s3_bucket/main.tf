#
# Bucket resource
#
resource "aws_s3_bucket" "bucket" {
  #Skipping checkov checks
  #checkov:skip=CKV_AWS_144: no s3 cross region replication
  #checkov:skip=CKV_AWS_145: Ensure that S3 buckets are encrypted with KMS by default <- CloudFront requires S3 AES256
  bucket_prefix = var.name_prefix
  force_destroy = true
}

#
# Versioning configuration
#
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

#
# Access logs
#
resource "aws_s3_bucket_logging" "logging" {
  bucket        = aws_s3_bucket.bucket.id
  target_bucket = var.log_bucket != null ? var.log_bucket : aws_s3_bucket.bucket.id
  target_prefix = "log/"
}

#
# SSE configration
#
resource "aws_s3_bucket_server_side_encryption_configuration" "sse_conf" {
  bucket = aws_s3_bucket.bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.kms_key_id
    }
  }
}

#
# Public access block
#
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#
# Dummy access policy 
#
data "aws_iam_policy_document" "policy" {
  statement {
    sid       = "DenyNonHttpsTrafic"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = [
      aws_s3_bucket.bucket.arn,
     "${aws_s3_bucket.bucket.arn}/*"
    ]
    principals {
      type = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = [false]
    }
  }
}

#
# Attaching policy to the bucket
#
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.bucket
  policy = coalesce(var.access_policy, data.aws_iam_policy_document.policy.json)
}