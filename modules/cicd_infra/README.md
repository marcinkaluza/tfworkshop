# What is this module for?
This module creates codebuild project with KMS encryption key and appropriate key policy.

# How do I use it?
Simple useage:

<code>
module "infra-build" { <br>
  &nbsp; source              = "../codebuild" <br>
  &nbsp; codecommit_repo     = var.repo_name <br>
  &nbsp; codebuild_role      = aws_iam_role.codebuild-role.arn <br>
  &nbsp; buildspec_file_name = "buildspec.yml" <br>
  &nbsp; project_name        = "infrastructure-build" <br>
}
</code>
<br>
<br>

# Inputs
|Variable name|Required|Description|
|-------------|--------|-----------|
|project_name|Yes|Name of the codebuild project|
|codecommit_repo|Yes|Name of the Codecommit repository|
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
|CKV_AWS_111|Ensure IAM policies does not allow write access without constraints|KMS key resource policy allows acess for the account root for all operations as per SOP|
|CKV_AWS_109|Ensure IAM policies does not allow permissions management / resource exposure without constraints|KMS key resource policy allows acess for the account root for all operations as per SOP|
