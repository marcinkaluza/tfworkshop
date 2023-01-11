# Exercise 2

## Introduction

The aim of this exercise is to move all VPC resources to a module structure.

![](../../images/Readme_Diagrams-Exercise%202.png)

## Prerequisites

For this exercise, all you need is your Terraform Backend built from  `exercise-1` with S3 and DynamoDB table outputs.


## Build VPC resources

Using Visual Studio editor, open `exercise-3` folder, you will be redeploying the VPC resources but with a module.

Don't forget to tell Terraform where to store AWS states by providing the details of the Backend you built in `exercise-1`, by updating the below values in `terraform.tf`:

```
bucket               = ""
```
```
terraform-state-lock = ""
```

Once you're done, go through the following steps from the terminal:

- Go to exercise-3
```
cd ../exercise-3
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

The solution can be found ready in `exercise-3/solution/` if needed.

## Conclusion

You can login to the AWS Console to verify that all resources have been properly created.

## Useful links

[Terraform AWS resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

[VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

[Default Security Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group)

[Internet Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)

[Elastic IP](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)

[NAT Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway)

[Subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)

[Route Table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)

[Route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)

[Route Table Association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)

