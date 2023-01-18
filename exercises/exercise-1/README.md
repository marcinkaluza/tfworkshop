# Exercise 1

## Introduction

When deploying, Terraform stores the state of each resource being deployed in order to keep track of all changes happening in a specific environment. Before deploying any new changes or resources, Terraform first does a refresh of the real infrastructure in order to compare the state against what will be deployed on top.

By default, Terraform stores this state locally. However, this can become an issue when several people are working on the same infrastructure since each of them has their own local state file which is likely to create conflicts across the configuration.

The solution is to get Terraform to store its state remotely, in the AWS account where the resources will be deployed, so that the state is centralised and accessible by anyone working on the same deployment. 

This is called a Terraform Backend and that's what we are going to create in this exercise, using an S3 bucket to store the state file and a DynamoDB table to lock the state. The same backend is then going to be used for all the exercises of this Immersion Day.

## Prerequisites

### Connect to AWS Cloud9 instance

To access your AWS account, follow the steps:
- Go to the EventEngine [dashboard](https://dashboard.eventengine.run/login)
- Enter the provided Hash Key
- Connect with OTP using your work email address
- Open AWS Console
- In the Console search bar, enter and select Cloud9
- Select the running Cloud9 instance and connect
  
### Tools

Using the Terminal, verify the below tools are already installed:
- For Git, run:
  
  ```
  git -v
  ```
- For Terraform, run:

  ```
  terraform --version
  ```
- For AWS, run:

  ```
  aws --version
  ```

### Enable auto-save
On the top left corner Cloud9 icon, select Preferences and go to Experimental, turn auto-save On.

### Disable AWS Temporary Credentials
On the top left corner Cloud9 icon, select Preferences, go to AWS Settings then on AWS Resources, disable AWS managed temporary credentials.

## Create Terraform backend

Using the Cloud9 editor, open `exercise-1` folder and browse through the files to see what configuration is missing.

Wherever configuration needs to be added, there is a `#TODO` in the comments. Alternatively, you can directly do a search with `CTRL + F` for all `#TODO` in `exercise-1`.

Once you're done, go through the following steps from the terminal:

- Go to exercise-1
```
cd /home/ec2-user/environment/tfworkshop/exercises/exercise-1
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

## Retrieve Backend outputs

If successfully configured, Terraform will output the names of the S3 bucket and DynamoDB table, make a note of both since you will need to provide these values in the next exercises. You can retrieve outputs of the configuration at any time using following command:
```
terraform output
```

#### NOTE

The solution can be found ready in `exercise-1/solution/` if needed.

## Conclusion

Login to the AWS console if not already, go to S3 to verify that a new bucket has been deployed, then go to DynamoDB and verify that a new table has been created.

## Useful links

[Terraform Remote State](https://developer.hashicorp.com/terraform/language/state/remote)

[S3 Bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)

[DynamoDB Table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table)

