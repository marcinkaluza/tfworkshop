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
# Bastion host
#
module bastion_host {
  source = "./modules/ec2"
  name = "Bastion host"
  subnet_id = module.vpc.vpc_private_subnet_ids[0]
}