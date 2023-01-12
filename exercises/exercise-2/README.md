# Exercise 2

## Introduction

The aim of this exercise is to create VPC resources in order to deploy a basic infrastructure. That includes the following components, as shown on the diagram as well:
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

![](../../images/Readme_Diagrams-Exercise%202.png)

## Prerequisites

For this exercise, all you need is your Terraform Backend built from  `exercise-1` with S3 and DynamoDB table outputs.


## Build VPC resources

Using Visual Studio editor, open `exercise-2` folder and browse through the files to see what configuration is missing.

Wherever configuration needs to be added, there is a `#TODO` in the comments. Alternatiely, you can directly do a search with `CTRL + F` for all `#TODO` in `exercise-2`.

Don't forget to tell Terraform where to store AWS states by providing the details of the Backend you built in `exercise-1`, by updating the below values in `terraform.tf`:

```
bucket               = ""
```
```
terraform-state-lock = ""
```

Once you're done, go through the following steps from the terminal:

- Go to exercise-2
```
cd ../exercise-2
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
terraform plan -var-file=var.tfvars
```
- Apply the configuration - this applies the configuration to the AWS account.
```
terraform apply -var-file=var.tfvars
```
Enter **yes** when prompted.

#### NOTE

The solution can be found ready in `exercise-2/solution/` if needed.

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

