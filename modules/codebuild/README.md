# What is this module for?
This module creates codebuild project with KMS encryption key and appropriate key policy.

# How do I use it?
Simple useage:

```hcl
module "infra-build" { 
  source              = "../codebuild" 
  codebuild_role      = aws_iam_role.codebuild-role.arn 
  buildspec_file_name = "buildspec.yml" 
  project_name        = "infrastructure-build" 
}
```
# Inputs
|Variable name|Required|Description|
|-------------|--------|-----------|
|project_name|Yes|Name of the codebuild project|
|codebuild_role|Yes|ARN of the IAM role to be used by the codebuild|
|buildspec_file_name|No|Name of the buildspec file. buildspec.yml will be used if not specified|
|compute_type|No|Type of the compute platform to be used. BUILD_GENERAL1_SMALL will be used if not specified|
# Outputs
|Output|Description|
|---|---|
|id|ID of the codebuild project|
|project_name|Name of the codebuild project|
# Ignored checkov warnings

|Warning|Description|Reason|
|---|---|---|
|CKV_AWS_111|Ensure IAM policies does not allow write access without constraints|False positive. Policy as per [documentation](https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html)|
|CKV_AWS_109|Ensure IAM policies does not allow permissions management / resource exposure without constraints|False positive. Policy as per [documentation](https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html)|
