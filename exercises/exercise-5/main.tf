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
#
# Create security group for the instances
#
resource "aws_security_group" "sg" {
  name        = "ec2_sg"
  description = "Allow VPC traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "HTTP in VPC"
    from_port        = 80
    to_port          = 80
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

#
# Autoscaling Group with Application Load Balancer
#
module "autoscaling-group" {
  source              = "./modules/autoscaling-group"
  vpc                 = module.vpc.vpc_id
  subnets             = module.vpc.vpc_private_subnet_ids
  alb_security_groups = [aws_security_group.sg.id]
  asg_security_groups = [aws_security_group.sg.id]
  user_data           = <<EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd.service
    sudo systemctl enable httpd.service
    echo “Hello ImmersionDay” > /var/www/html/index.html
  EOF
  
}