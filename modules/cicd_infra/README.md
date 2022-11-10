# What is this module for?
This module creates supporting infrastructure to deploy Terraform based IaC on AWS:
* S3 Bucket and dynamo db table to store terraform state (Terraform S3 backend)
* CodeCommit repository, CodePipeline and two CodeBuild projects to be used for infrastructure/terraform deployment
* IAM user account that can be used for mirroring of gitlab repositories to CodeComit. 

The build projects are there to perform security check and actual deployment of the infrastructure. They expect that the source code contains **buildspec-sec.yml** file containing instructions to run the security (checkov) scan and **buildspec.yml** containing instructions to deploy the infrastructure.  

# How do I use it?
This module is intended to be used on its own and not to be executed as part of PoC's Terraform configuration. 
In order to deploy it, follow the steps below:
1. Modify policy.json file which requires IAM policy that will be attached to terraform role that this module creates. You need to make sure that the policy allows creation, update and deletion of all resource types you intend to create using Terraform
2. Ensure you have Terraform installed on your local machine
3. In the terminal window execute following command, replacing values of the variables as appropriate
```
terraform apply -var target_region=eu-west-1 -var repo_name=my-infra-repo
```
4. Once applied, commit the terraform.tfstate file to gitlab (in case you need to modify or customize the pipeline at some point in the future)
5. You can access outputs of the module by running following command:
```
terraform output -json
```

```json
{
  "git_password": {
    "sensitive": true,
    "type": "string",
    "value": "KhWt8rxxR48gtoh5WSatFmeYRlT+KYnpuXzzyalN7e8="
  },
  "git_repo_url": {
    "sensitive": false,
    "type": "string",
    "value": "https://git-codecommit.eu-west-1.amazonaws.com/v1/repos/terraform-assets"
  },
  "git_user_name": {
    "sensitive": false,
    "type": "string",
    "value": "gitlab-user-at-978200889980"
  },
  "terraform_lock_table": {
    "sensitive": false,
    "type": "string",
    "value": "tf-state-lock"
  },
  "terraform_role": {
    "sensitive": false,
    "type": "string",
    "value": "arn:aws:iam::978200889980:role/terraform-assets_terraform_role"
  },
  "terraform_state_bucket": {
    "sensitive": false,
    "type": "string",
    "value": "tf-state-20221110110918070500000001"
  }
}
```
Take note of gitlab-user credentials necessary to setup mirroring of your gitlab repo. The **terraform_state_bucket** and **terraform_lock_table** outputs should be used to configure terraform backend ([backend.config](../../resources/backend.config) file in the /resources directory)
# Inputs
|Variable name|Required|Description|
|-------------|--------|-----------|
|target_region|Yes|Target region where the resources are to be created|
|repo_name|Yes|Name of the Codecommit repository to be created|
# Outputs
|Output|Description|
|---|---|
|git_repo_url|URL of the CodeCommit repository to be used to set up mirroring|
|git_password|Password to be used to set up repo mirroring|
|git_user_name|Name of the user to be used for setting up repo mirroring|
|terraform_role|ARN of the role that will be used to deploy infrastructure|
|terraform_state_bucket|Name of the S3 bucket to be used to store terraform state|
|terraform_lock_table|Name of a DynamoDB table to store terraform locks|

# Ignored checkov warnings

|Warning|Description|Reason|
|---|---|---|
|CKV_AWS_40|Ensure IAM policies are attached only to groups or roles (Reducing access management complexity may in-turn reduce opportunity for a principal to inadvertently receive or retain excessive privileges.)|Policies attached to gitlab-user account to allow access to CodeCommit repo (for mirroring purposes)
|CKV2_AWS_37|Ensure Codecommit associates an approval rule|Surplus to requirements as we use gitlab as primary source control tool|
|CKV_AWS_111|Ensure IAM policies does not allow write access without constraints|KMS key resource policy allows acess for the account root for all operations as per SOP|
|CKV_AWS_109|Ensure IAM policies does not allow permissions management / resource exposure without constraints|KMS key resource policy allows acess for the account root for all operations as per SOP|
