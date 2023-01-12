# Exercise 4

## Introduction

In this exercise, you will create an EC2 module in order to build a private EC2 instance, called a Bastion, including an IAM role to allow remote access via System Manager.

![](./../../images/Readme_Diagrams-Exercise%204.png)

## Prerequisites

For this exercise, all you need is your Terraform Backend built from  `exercise-1` with S3 and DynamoDB table outputs.

## Build EC2 module

Using Visual Studio editor, open `exercise-4` folder and browse through the files to see what configuration is missing.

Wherever configuration needs to be added, there is a `#TODO` in the comments. Alternatiely, you can directly do a search with `CTRL + F` for all `#TODO` in `exercise-4`.

Don't forget to tell Terraform where to store AWS states by providing the details of the Backend you built in `exercise-1`, by updating the below values in `terraform.tf`:

```
bucket               = ""
```
```
terraform-state-lock = ""
```

Once you're done, go through the following steps from the terminal:

- Go to exercise-4
```
cd ../exercise-4
```
- Format Terraform configuration.
```
terraform fmt -recursive
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

The solution can be found ready in `exercise-4/solution/` if needed.

## Conclusion

You can login to the AWS Console to verify that all resources have been properly created.

You can try connecting to the Bastion instance by going to the EC2 dashboard, then select the instance and connect. You will be connected via System Manager which allows to connect privately to instances.

## Useful links

[All Terraform AWS resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

[EC2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

[Security Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)