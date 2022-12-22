# Exercise 3

## Introduction

The aim of this exercise is to move the VPC resources to a module structure.

## Prerequisites

The previously setup:
- Cloud9 machine
- Terraform backend

## Build VPC module

### Update Terraform backend

Update these 2 lines with the output values you saved from `exercise-1` in `terraform.tf`:

```
bucket               = ""
```
```
terraform-state-lock = ""
```

### Build module

1. Create a folder called `modules` and copy the following files into it : `main.tf`, `variables.tf`, `outputs.tf`.

2. Delete variable file `var.tfvars`, we won't need it anymore since we will hardcode the values into the main file (NOT recommended for Production).

3. Declare the VPC module into the main (root folder) `main.tf` by adding the below:

```
module "vpc" {
  source                      = "./modules/vpc"
  name                        = "My VPC"
  cidr_block                  = "10.0.0.0/16"
  private_subnets_cidr_blocks = ["10.0.1.0/24", "10.0.3.0/24"]
  public_subnets_cidr_blocks  = ["10.0.2.0/24", "10.0.4.0/24"]
}
```

### Deploy the Terraform code

From your terminal, enter exercise 3 folder (i.e.`cd exercise-3`):

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

You should notice that all VPC resources from the previous exercise are being destroyed and re-deployed as configured in the module.

## Useful links

[Terraform AWS resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)