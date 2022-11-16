output "cloudfront_domain_name" {
  value       = resource.aws_cloudfront_distribution.distribution.domain_name
  description = "Domain name of cloudfront distribution"
}

output "cloudfront_hosted_zone_id" {
  value       = resource.aws_cloudfront_distribution.distribution.hosted_zone_id
  description = "Hosted zone id of cloudfront distribution"
}

output "cloudfront_distribution_id" {
  value       = resource.aws_cloudfront_distribution.distribution.id
  description = "Distribution id of cloudfront distribution"
}

output "cloudfront_distribution_arn" {
  value       = resource.aws_cloudfront_distribution.distribution.arn
  description = "ARN of cloudfront distribution"
}

output "website_bucket_arn" {
  value       = module.website_bucket.arn
  description = "ARN of website hosting bucket"
}

output "website_bucket_name" {
  value       = module.website_bucket.name
  description = "Name of website hosting bucket"
}

output "oai_iam_arn" {
  value       = resource.aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
  description = "IAM arn of the OAI. This attribute is a pre-generated ARN for use in S3 bucket policies"
}