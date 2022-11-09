# What is this module for
Creates ressources for CloudFront distribution:
- An S3 bucket for the static website
- An S3 bucket for access logs
- A CloudFront Origin Access Identity
- A CloudFront Distribution
- A Route 53 record for the website



**NOTE:** Why you must use AES256 encryption on the S3 bucket:
CloudFront currently does not support KMS server-side encryption for S3. The reason this does not work is that viewer requests through CloudFront does not have access to the KMS credentials used to encrypt the s3 objects. We would recommend using signed URLs and Origin Access Identities without KMS. We are aware of this limitation and a feature request is submitted to the CloudFront team.

# How do I use it?
Simple useage:

```hcl
module "cloudfront-distribution" {
 source               = "./modules/cloudfront-distribution" 
 acm_certificate_arn  = acm_certificate_arn 
 s3_bucket_prefix     = "my-bucket-prefix" 
 cloudfront_alias     = "myDomain"
 r53_zone_id          = "aws_route53_zone_id"
 apigw_origin_enabled = false
 api_domain_name      = "api_domain"
 api_origin_id        = "API" 
 web_acl_id           = "my_web_acl" 
}
```

# Inputs
|Variable name|Required|Description|
|-------------|--------|-----------|
|acm_certificate_arn|Yes||
|s3_bucket_prefix|Yes||
|cloudfront_alias|Yes||
|r53_zone_id|Yes||
|apigw_origin_enabled|Yes||
|api_domain_name|Yes||
|api_origin_id|Yes||
|web_acl_id|Yes||

# Outputs
|Output|Description|
|---|---|
|cloudfront_domain_name|Domain name of cloudfront distribution|
|cloudfront_hosted_zone_id|Hosted zone id of cloudfront distribution|
|cloudfront_distribution_id|Distribution id of cloudfront distribution|
|cloudfront_distribution_arn|ARN of cloudfront distribution|
|website_bucket_arn|ARN of website hosting bucket|
|website_bucket_name|Name of website hosting bucket|
|oai_iam_arn|IAM arn of the OAI. This attribute is a pre-generated ARN for use in S3 bucket policies|

# Ignored checkov warnings

|Warning|Description|Reason|
|---|---|---|
||||