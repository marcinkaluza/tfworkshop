# What is this module for?
This module creates following resources:
* CodeCommit repository for the lambda function code
* CodeBuild project for the build and deployment of the lambda function
* S3 bucket for storage of the built lambda code
* Required roles and IAM policies


# How do I use it?
Simple useage:

```hcl
module lambda_pipeline {
    source = "../modules/cicd_lambda"
    function_name = "image-service"
    function_arn = module.lambda.arn
}
```
# Inputs
|Variable name|Required|Description|
|-------------|--------|-----------|
|function_name|Yes|Name of the lambda function|
|function_arn|Yes|ARN of the lambda function|

# Outputs
|Output|Description|
|---|---|

# Ignored checkov warnings

|Warning|Description|Reason|
|---|---|---|
|CKV2_AWS_37|Ensure Codecommit associates an approval rule| Surplus to requirements as CodeCommit repo is used only as a target for mirroring gitlab repo|
