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

#### NOTE

In this exercise, all resources have been pre-written for you, you do not need to make any changes on the resources.

If you wish to play around with the EC2 resource arguments, refer to the documentation at the bottom section.

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

[Autoscaling Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)

[Launch Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration)

[Application Load Balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)

[All Terraform AWS resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)