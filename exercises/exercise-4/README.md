# Exercise 4

## Introduction

In this exercise, you will create an EC2 module in order to build a private EC2 instance with an IAM role to allow remote access via System Manager.

## Prerequisites

The previously setup:
- Cloud9 machine
- Terraform backend
- VPC module structure

## Build EC2 module

### Update Terraform backend

Update these 2 lines with the output values you saved from `exercise-1` in `terraform.tf`:

```
bucket               = ""
```
```
terraform-state-lock = ""
```

### Build module

1. In the EC2 module, fill in the missing arguments of the EC2 instance resource.

2. In the main (root folder) `main.tf`, fill in the missing variables to declare the EC2 module correctly.

3. In the main (root folder) `main.tf`, fill in the missing arguments to create the security group for the EC2 bastion instance.

### Deploy the Terraform code

From your terminal, enter exercise 3 folder (i.e.`cd exercise-4`):

1) Initialize Terraform - this downloads all required plugins and providers for this deployment, and locates the remote backend built in `exercise-1`.
```
terraform init
```
1) Create a plan of the deployment - this shows you what is going to be deployed.
```
terraform plan
```
1) Apply the configuration - this applies the configuration to the AWS account.
```
terraform apply -auto-approve
```

## Conclusion

You can login to the AWS Console to verify that all resources have been properly created.

## Useful links

[All Terraform AWS resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

[EC2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

[Security Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)