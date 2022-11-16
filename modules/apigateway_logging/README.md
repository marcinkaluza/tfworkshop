# What is this module for?
This module creates following resources:
* IAM role to enable API gateway to use CloudWatch logs
* API gateway account using the role

# How do I use it?
Simple useage:

```hcl
module mymodule { 
   source = "../modules/apigatewa_logging" 
}
```
# Inputs
None
# Outputs
None
# Ignored checkov warnings

|Warning|Description|Reason|
|---|---|---|
|CKV_AWS_111|Ensure IAM policies does not allow write access without constraints|The role needs access to all Cloudwatch logs as it creates both log streams and log groups as per [documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html) |
