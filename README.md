# Terraform Assets
This project contains reuseable Terraform modules intended for building infrastructure required by our PoCs. 

All of the modules included in this project:
* are being scaned for vulnerabilities and best practices using checkov
* have been "battle tested" in a number of previous engagements 
* have gone through Prototype Security Review process at least once
* can be used as a starting point for a POC or an EBA that require IaC in Terraform

Each module comes with an example of how to use it. All examples can be found in the [examples](./examples) directory.

## How to use shared Terraform assets

When starting a PoC or preparing for an EBA, follow the steps below to get started with building your infrastructure:

1. Fork the repository: simply navigtate to https://gitlab.aws.dev/aws-gfs-acceleration/MigX/assets/terraform-assets and click the "Fork" button
2. Clone the new (forked) repository to your local drive
3. Create your resoures in the **main.tf** file in the **resources** directory and deploy as normal i.e by running

`
   terraform apply -var my_variable=something
`

4. If you would like to create a CICD pipeline in your AWS account for automatic deployment of your infrastructure, follow the instructions in the section below

## Creating CICD pipeline for infrastructure build

In order to create a CICD pipeline for automatic deployment of the infrastructure, follow the steps below:

1. Create S3 bucket and DynamoDB table to store terraform state and locks in your AWS account. The [bootstrap](./modules/bootstrap/README.md) directory contans a simple TF configuration that allows just that using bootstrap module by Trussworks. Follow instructions in the [README.md](./modules/bootstrap/README.md) to deploy it.
2. Create CICD pipeline, repository and build projects using [cicd_infra](./modules/cicd_infra/READEME.md) module. For detailed instructions refer to the [README.md](./modules/cicd_infra/READEME.md). The module creates Codecommit repository and AWS user account with access to the repo.
3. Use module outputs from the previous step to set up mirroring between your gitlab repository and code commit:
* In gitlab, navigate yo your repository **Settings** page.
* Select the **Repository** section in the **Settings** menu
* Clicke the **Expand** button next to the **Mirroring repositories** section
* Add code commit repository url in the following format:
`
https://<USER_NAME>@<REPO_URL>
`
where the USER_NAME and REPO_URL are both outputs from the step 2. e.g. https://gitlab-user-at-123456789012@git-codecommit.eu-west-1.amazonaws.com/v1/repos/mypoc
* Input the password obtained in step 2. into the **Password** field
* Click the **Mirror repository** button

Once the steps above are completed, the code from the gitlab repository will be replicated to CodeCommit and each change will result in the execution of the code pipeline. The pipeline will run checkov scan of your resources and then deploy them in your AWS account.

## Available modules

The modules directory contains following modules:

| Module    | Description |
|-----------| ----------------------------------|
| [bootstrap](./modules/bootstrap/README.md) | Standalone module to create Terraform state storage in S3 |
| [cicd_infra](./modules/cicd_infra/READEME.md)| CodeCommit repository and build pipeline for infrastructure projects|
| [s3_bucket](./modules/s3_bucket/READEME.md) | S3 Bucket with encryption, access logging etc. |

## Contributing
Please refer to [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines how to contribute to this project.

