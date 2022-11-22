# Terraform Assets
This project contains reuseable Terraform modules intended for building infrastructure required by our PoCs. 

All of the modules included in this project:
* are being scaned for vulnerabilities and best practices using checkov
* have been "battle tested" in a number of previous engagements 
* have gone through Prototype Security Review process at least once
* can be used as a starting point for a POC or an EBA that require IaC in Terraform

## How to use shared Terraform assets

When starting a PoC or preparing for an EBA, follow the steps below to get started with building your infrastructure:

1. Fork the repository: simply navigtate to https://gitlab.aws.dev/aws-gfs-acceleration/MigX/assets/terraform-assets and click the "Fork" button
2. Clone the new (forked) repository to your local drive
3. Create a CICD pipeline in your AWS account for automatic deployment of your infrastructure by following instructions in the section below
4. Create your resoures in the **main.tf** file in the **resources** directory and deploy as normal i.e by running

```
   terraform apply -var my_variable=something
```

## Creating CICD pipeline for infrastructure build

In order to create a CICD pipeline for automatic deployment of the infrastructure, follow the steps below:

1. Create CICD pipeline, repository and build projects using [cicd_infra](./modules/cicd_infra/README.md) module. For detailed instructions refer to the [README.md](./modules/cicd_infra/README.md). The module creates Codecommit repository and AWS user account with access to the repo.
2. Use module outputs from the previous step to set up mirroring between your gitlab repository and code commit:
* In gitlab, navigate yo your repository **Settings** page.
* Select the **Repository** section in the **Settings** menu
* Clicke the **Expand** button next to the **Mirroring repositories** section
* Add code commit repository url in the following format:
`
https://<USER_NAME>@<REPO_URL>
`
where the USER_NAME and REPO_URL are both outputs from the step 2. e.g. https://gitlab-user-at-123456789012@git-codecommit.eu-west-1.amazonaws.com/v1/repos/mypoc
* Input the password obtained in step 2. into the **Password** field
* Click the **Mirror repository** button<br><br>
Once the steps above are completed, the code from the gitlab repository will be replicated to CodeCommit and each change will result in the execution of the CodePipeline. The pipeline will run checkov scan of your resources and then deploy them in your AWS account.
3. Modify the [backend.config](/resources/backend.config) file and set the name of the dynamo db table and S3 bucket to be used for TF state storage. Use outputs from step 1 to get both the bucket and table name.

## Available modules

The modules included in this project come into three flavours:
* top level modules intended for reuse in PoCs
* standalone modules which are not intended to be used as part of PoCs infrastructure
* low level modules (building blocks) intended to be used when building other modules

### Standalone modules

| Module    | Description |
|-----------| ----------------------------------|
|[cicd_infra](./modules/cicd_infra/README.md)| CodeCommit repository and build pipeline for infrastructure projects|

### Top level modules

| Module    | Description |
|-----------| ----------------------------------|
|[acm_ssl_certificate](./modules/acm_ssl_certificate/README.md)|SSL certificate|
|[apigateway_logging](./modules/apigateway_logging/README.md)|IAM role and account to enable API gateway access to CloudWatch|
|[apigateway_rest](./modules/apigateway_rest/README.md)|REST API with two stages, logs and deployments|
|[cicd_lambda](./modules/cicd_lambda/README.md)|CICD pipeline and related resources for build and deployment of lambda functions|
|[cloudfront_distribution](./modules/cloudfront-distribution/README.md)|Cloudfront distribution with an S3 bucket and optional API origin|
|[kms](./modules/kms/README.md)|KMS key, alias and default access policy|
|[lambda](./modules/lambda/README.md)|Lambda function with prod and test aliases|
|[s3_bucket](./modules/s3_bucket/README.md) | S3 Bucket with encryption, access logging etc. |
|[vpc](./modules/vpc/README.md)|VPC, private and public subnets, service endpoints


### Low level modules
| Module    | Description |
|-----------|----------------------------------|
| [cicd_eventbridge_trigger](./modules/cicd_eventbridge_trigger/README.md) | Eventbridge trigger to execute CodePipeline on commit in CodeCommit repository |
| [codebuild](./modules/codebuild/README.md) | Codebuild project |


## Contributing
Please refer to [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines how to contribute to this project.

