# Exercise 2

## Introduction

The aim of this exercise is to create VPC resources required to build a basic infrastructure. That includes the following components:
- Base infrastructure
  - VPC
  - Private subnets
  - Public subnets
- VPC route tables
  - Private route table
  - Public route table
- Egress connectivity to the Internet
  - NAT Gateway
  - Internet Gateway
- Default Security Group associated to the VPC

## Prerequisites

The previously setup:
- Cloud9 machine
- Terraform backend

## Build VPC environment

### Build the Terraform code

Open exercise-2 with a text editor, you should have the following files.

#### main.tf

This is the main file on which you need to work, all the new resources that will be deployed will be created in this file.

All resources are already defined in the file but left empty for you to state the correct arguments inside by referring to the Terraform AWS Resources documentation.

**Example: AWS VPC**
```
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block     # This is required to define the size and ip addressing of the VPC network
  enable_dns_hostnames = true               # This is optional but useful since it allows DNS resolution inside the VPC
  enable_dns_support   = true               # This is optional but useful since it allows DNS resolution inside the VPC

  tags = {
    Name = var.name                         # This is optional
  }
}
```
[Terraform Documentation for VPC resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

#### variables.tf

These are the pre-defined variables that must used in your `main.tf`.

There is nothing to do here.

#### var.tfvars

These are the pre-defined values of the variables defined in `variables.tf`.

There is nothing to do here.

#### outputs.tf

These are the pre-defined output values that will come out of the deployment.

There is nothing to do here.

#### terraform.tf

This defines the providers required for this deployment, such as AWS given we are deploying AWS resources, as well as the existing Terraform backend that will be used to store states.

You need to update these 2 lines with the output values you saved from `exercise-1`:

```
bucket               = ""
```
```
terraform-state-lock = ""
```

#### NOTE

The solution can be found ready in `exercise-2/solution/` if needed.

### Deploy the Terraform code

When the resources are ready to be created, from your terminal, enter exercise 2 folder (i.e.`cd exercise2`):

1) Initialize Terraform - this downloads all required plugins and providers for this deployment, and locates the remote backend built in `exercise-1`.
```
terraform init
```
1) Create a plan of the deployment - this shows you what is going to be deployed.
```
terraform plan --var-file=var.tfvars
```
1) Apply the configuration - this applies the configuration to the AWS account.
```
terraform apply --var-file=var.tfvars -auto-approve
```

## Conclusion

You can login to the AWS Console to verify that all resources have been properly created.

## Useful links

[Terraform AWS resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)