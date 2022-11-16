# What is this module for
Creates an ACM SSL certificate for CloudFront Distribution

**NOTE:** The ACM certificate and it's validation **MUST BE IN US-EAST-1** region.

# How do I use it?
Simple useage:

```hcl
module "acm-ssl-certificate" {
 source               = "./modules/acm-ssm-certificate" 
 r53_zone_id          = "aws_route53_zone_id"
 domaine_name         = "myDomain"
}
```

# Inputs
|Variable name|Required|Description|
|-------------|--------|-----------|
|route53_zone_id|Yes|Hosted Zone ID for a CloudFront distribution.|
|domain_name|Yes|Domain name for which the certificate should be issued|


# Outputs
|Output|Description|
|---|---|
|acm_certificate_arn|ARN of ACM Certificate|


# Ignored checkov warnings

|Warning|Description|Reason|
|---|---|---|
