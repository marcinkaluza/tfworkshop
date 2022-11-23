# What is this module for?
This module creates following resources:
* VPC
* Public subnets
* Private subnets
* NAT gateway in each public subnet
* Private and public route tables
* Default security groups
* Optionally interface and/or gateway endpoints for AWS services

# How do I use it?
Simple useage:

```hcl
module "vpc" {
  source                      = "../modules/vpc"
  name                        = "Main VPC"
  cidr_block                  = "10.0.0.0/16"
  public_subnets_cidr_blocks  = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
  private_subnets_cidr_blocks = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
  interface_endpoint_services = ["ec2", "logs"]
  gateway_endpoint_services   = ["s3"]
}
```
# Inputs
|Variable name|Required|Description|
|-------------|--------|-----------|
|name|Yes|Explain use of the variable|
|cidr_block|Yes|CIDR block for the VPC|
|public_subnets_cidr_blocks|Yes|List of CIDR blocks for the public subnets. Can be empty, if **allow_internet_egress** is set to false|
|private_subnets_cidr_blocks|Yes|List of CIDR blocks for the private subnets|
|allow_internet_egress|No|Set to false to block internet egress from private subnets. If true (the default), the number of public subnets must be the same as the number of private subnets|
|interface_endpoint_services|No|List of AWS services for which private interface endpoints should be created .e.g. ["ec2","kms"]|
|gateway_endpoint_services|No|List of AWS services for which gateway endpoints should be created (only supported for s3 and dynamodb)|



# Outputs
|Output|Description|
|---|---|
|vpc_id|ID of the VPC created|
|vpc_private_subnet_ids|IDs of the private subnets|
|vpc_public_subnet_ids|IDs of the public subnets|

# Ignored checkov warnings

|Warning|Description|Reason|
|---|---|---|
|CKV_AWS_111|Ensure IAM policies does not allow write access without constraints|False positive. Policy as per [documentation](https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html)|
|CKV_AWS_109|Ensure IAM policies does not allow permissions management / resource exposure without constraints|False positive. Policy as per [documentation](https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html)|
