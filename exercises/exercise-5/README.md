# Exercise 5

## Introduction

In this exercise, you will create a new module in order to build the following components:
- Austoscaling Group
  - 3 EC2 instances with 'Hello world' type web page
  - IAM role for SSM remote access
- Application Load Balancer to front the autoscaling group

## Prerequisites

The previously setup:
- Cloud9 machine
- Terraform backend
- Module structure

## Build EC2 module

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

If you wish to play around with the autoscaling and load balancer resources arguments, refer to the documentation at the bottom section.

### Deploy the Terraform code

From your terminal, enter exercise 3 folder (i.e.`cd exercise-5`):

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

## TEST

TEST WITH BENCH EC2 ON ASG INSTANCES.

## Useful links

[Terraform AWS resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
