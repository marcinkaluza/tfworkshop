# What is this module for
Create a cloudfront distribution

Why you must use AES256 encryption on the S3 bucket:
CloudFront currently does not support KMS server-side encryption for S3. The reason this does not work is that viewer requests through CloudFront does not have access to the KMS credentials used to encrypt the s3 objects. We would recommend using signed URLs and Origin Access Identities without KMS. We are aware of this limitation and a feature request is submitted to the CloudFront team.

# How do I use it?
Simple useage:

<code>
module mybucket { <br>  
   &nbsp; source = "../modules/s3_bucket" <br>
   &nbsp; name_prefix = "my_bucket_" <br>
}
</code>
<br>
<br>

# Inputs
|Variable name|Required|Description|
|-------------|--------|-----------|
|name_prefix|Yes|Prefix of the S3 bucket name. TF will automaticaly generate bucket name using this prefix. **NOTE:** S3 bucket names do not accept uppercase characters in their names!|
|sse_algorithm|No|By default **aws:kms** will be used. **AES256** can be specified if the bucket is to be used with CloudFront.
|log_bucket|No|Name of the bucket where access logs are to be stored. If not specified, the bucket will store the logs with the /log prefix in itself.|

# Outputs
|Output|Description|
|---|---|
|name|Generated name of the bucket|
|arn|ARN of the bucket created|
|regional_domain_name|The bucket region-specific domain name. Used for creating Cloudfront S3 origins|

# Ignored checkov warnings

|Warning|Description|Reason|
|---|---|---|
|CKV_AWS_144|Ensure that S3 bucket has cross-region replication enabled|Redundant to requirements
|CKV_AWS_145|Ensure that S3 buckets are encrypted with KMS by default|We need to allow AES256 encryption for Cloudfront