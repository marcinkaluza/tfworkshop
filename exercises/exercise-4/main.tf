locals {
  cidr_block = "10.0.0.0/16"
}
#
# Module for VPC
#
module "vpc" {
  source                      = "./modules/vpc"
  name                        = "My VPC"
  cidr_block                  = "10.0.0.0/16"
  private_subnets_cidr_blocks = ["10.0.1.0/24", "10.0.3.0/24"]
  public_subnets_cidr_blocks  = ["10.0.2.0/24", "10.0.4.0/24"]
}

# Security group for the EC2 instance
resource "aws_security_group" "sg" {
  name        = "ec2_sg"
  description = "Allow VPC traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Traffic inside the VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = [local.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

#
# Bastion host
#
module "bastion_host" {
  source                 = "./modules/ec2"
  name                   = "Bastion host"
  subnet_id              = module.vpc.vpc_private_subnet_ids[0]
  user_data              = <<EOF
    #!/bin/bash
    sudo yum install -y httpd-tools
  EOF
  vpc_security_group_ids = [aws_security_group.sg.id]
}