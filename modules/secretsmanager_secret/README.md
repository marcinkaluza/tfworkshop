# What is this module for?
This module creates following resources:
* Secret Manager secret
* KMS encryption key
* Optional rotation configuration

# How do I use it?
Simple useage:

```hcl
module "secret" {
  source        = "../modules/secretsmanager_secret"
  name          = "test_secret"
  secret_string = "Pa$$w0rd"
  roles         = [aws_iam_role.test_role.arn]
}
```
# Inputs
|Variable name|Required|Description|
|-------------|--------|-----------|
|name|Yes|Name of the secret|
|secret_string|Yes|Secret string to store inside the secret|
|roles|Yes|Roles that will be granted permission to KMS key used for encryption of the secret|
|rotation_lambda_arn|No|ARN of a lambda function that will be used to rotate the secret|
|rotation_interval|No|Rotation interval in days (defaults to 7)|

# Outputs
|Output|Description|
|---|---|
|arn|ARN of the secret|

# Ignored checkov warnings

None

