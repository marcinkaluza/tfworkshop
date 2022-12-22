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

## Build Autoscaling Group module

### Update Terraform backend

Update these 2 lines with the output values you saved from `exercise-1` in `terraform.tf`:

```
bucket               = ""
```
```
terraform-state-lock = ""
```

### Build module

1. In the autoscaling-group module, fill in the missing arguments of the resources.
   
2. Fill in correct value to declare the load balancer DNS output in `outputs.tf`.

3. In the main (root folder) `main.tf`, fill in the missing variables to declare the autoscaling-group module correctly.

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

[Load Balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)

[Target Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group)

[Listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener)

[Launch Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration)

[Autoscaling Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)

[Autoscaling Group Attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment)