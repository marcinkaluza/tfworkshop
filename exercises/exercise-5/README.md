# Exercise 5

## Introduction

In this exercise, you will create a new module in order to build the following components:
- Austoscaling Group
  - 3 EC2 instances with 'Hello world' type web page
  - IAM role for SSM remote access
- Application Load Balancer to front the autoscaling group

![](./../../images/Readme_Diagrams-Exercise%205.png)

## Prerequisites

For this exercise, all you need is your Terraform Backend built from  `exercise-1` with S3 and DynamoDB table outputs.

## Build Autoscaling Group module with Network Load Balancer

Using Visual Studio editor, open `exercise-5` folder and browse through the files to see what configuration is missing.

Wherever configuration needs to be added, there is a `#TODO` in the comments. Alternatiely, you can directly do a search with `CTRL + F` for all `#TODO` in `exercise-5`.

Don't forget to tell Terraform where to store AWS states by providing the details of the Backend you built in `exercise-1`, by updating the below values in `terraform.tf`:

```
bucket               = ""
```
```
terraform-state-lock = ""
```

Once you're done, go through the following steps from the terminal:

- Go to exercise-5
```
cd ../exercise-5
```
- Format Terraform configuration.
```
terraform fmt
```
- Initialize Terraform - this downloads all required plugins and providers for this deployment.
```
terraform init
```
- Validate Terraform configuration to make there is no obvious errors.
```
terraform validate
```
- Create a plan of the deployment - this shows you what is going to be deployed.
```
terraform plan
```
- Apply the configuration - this applies the configuration to the AWS account.
```
terraform apply
```
Enter **yes** when prompted.

#### NOTE

The solution can be found ready in `exercise-5/solution/` if needed.

## Conclusion

You can login to the AWS Console to verify that all resources have been properly created.

## Test the solution

TESTING STEPS

## Useful links

[Terraform AWS resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

[Load Balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)

[Target Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group)

[Listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener)

[Launch Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration)

[Autoscaling Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)

[Autoscaling Group Attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment)