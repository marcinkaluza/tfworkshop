# Exercise 3

## Introduction

The aim of this exercise is to move the VPC resources to a module structure.

## Prerequisites

The previously setup:
- Cloud9 machine
- Terraform backend

## Build VPC environment

### Update Terraform backend

Update these 2 lines with the output values you saved from `exercise-1` in `terraform.tf`:

```
bucket               = ""
```
```
terraform-state-lock = ""
```

#### NOTE

In this exercise, all resources have been pre-written for you, you do not need to make any changes on the resources.

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

You should notice that all VPC resources from the previous exercise are being destroyed and reployed as configured in the module.

## Useful links

[Terraform AWS resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)