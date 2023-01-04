# Exercise 1

## Introduction

When deploying, Terraform stores the state of each resource being deployed in order to keep track of all changes happening in a specific environment. Before deploying any new changes or resources, Terraform first does a refresh of the real infrastructure in order to compare the state against what will be deployed on top.

By default, Terraform stores this state locally. However, this can become an issue when several people are working on the same infrastructure since each of them has their own local state file which is likely to create conflicts across the configuration.

The solution is to get Terraform to store its state remotely, in the AWS account where the resources will be deployed, so that the state is centralised and accessible by anyone working on the same deployment. 

This is called a Terraform Backend and that's what we are going to create in this exercise, using an S3 bucket to store the state file and a DynamoDB table to lock the state. The same backend is then going to be used for all the exercises of this Immersion Day.

## Prerequisites

### Tools

- A Cloud9 machine with an associated IAM role or AWS credentials to deploy resources in the AWS account.
- Git cli - already on cloud9 ?
- Terraform cli - already on cloud9 ?
- A text editor - already on cloud9 ?

### Clone Github repository

On a browser, go to this [Gihub repository](github.com) **TO BE UPDATED**, click on `clone` and copy the HTTPS URL.

On your Cloud9 machine, open your terminal and type:

```
git clone <HTTPS URL>
```

Make sure the content has been copied to your local machine.

## Create Terraform backend

From your terminal, enter exercise 1 folder (i.e.`cd exercise-1`) and deploy the backend with Terraform.

1) Initialize Terraform - this downloads all required plugins and providers for this deployment.
```
terraform init
```
2) Create a plan of the deployment - this shows you what is going to be deployed.
```
terraform plan
```
1) Apply the configuration - this applies the configuration to the AWS account.
```
terraform apply -auto-approve
```

In the terminal, Terraform will output the names of the S3 bucket and DynamoDB table, make a note of the values since you will need to provide them in the next exercises.

## Conclusion

Login to the AWS console if not already, go to S3 to verify that a new bucket has been deployed, then go to DynamoDB and verify that a new table has been created.

## Useful links

[Terraform Remote State](https://developer.hashicorp.com/terraform/language/state/remote)

[S3 Bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)

[DynamoDB Table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table)

