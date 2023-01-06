locals {
  cidr_block = "10.0.0.0/16"
}
#
# Module for VPC
#
module "vpc" {
  source                      = "./modules/vpc"
  name                        = "My VPC"
  cidr_block                  = local.cidr_block
  private_subnets_cidr_blocks = ["10.0.1.0/24", "10.0.3.0/24"]
  public_subnets_cidr_blocks  = ["10.0.2.0/24", "10.0.4.0/24"]
}

# Creates security group for the EC2 instance, which should be attached to the VPC, with ingress open on all ports restricted in VPC CIDR, and egress open for all
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
#
resource "aws_security_group" "sg" {
  name        = "ec2_sg"
  description = "Allow VPC traffic"
  vpc_id      = module.vpc.vpc_id

  # Allow ingress from the VPC CIDR on all ports/protocols
  # ingress {
  # }

  # # Allow egress to the vpc on all ports and protocols
  # egress {
  # }

  # # Allow egress to the internet on TCP port 443
  # egress {
  # }
}

#
# Find the latest AMI
#
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

#
# Declares EC2 module to create a bastion host, filling the variables values that needs defining.
#
module "bastion_host" {
  source                 = "./modules/ec2"
  name                   = "Bastion host"
  subnet_id              = module.vpc.vpc_private_subnet_ids[0]
  ami_id                 = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  user_data              = <<EOF
    #!/bin/bash
    sudo yum install -y httpd-tools
  EOF
  vpc_security_group_ids = [aws_security_group.sg.id]
}