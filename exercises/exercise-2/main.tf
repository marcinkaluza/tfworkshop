data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

#
# Creates a simple VPC using variable cidr_block and with DNS resolution enabled.
#
resource "aws_vpc" "main" {

}

#
# Creates a default security group withg no rules, associated to the VPC.
#
resource "aws_default_security_group" "default" {

}

#
# Creates an Internet gateway associated to the VPC.
#
resource "aws_internet_gateway" "igw" {

}

#
# Creates an elastic IP (EIP) to associate to a NAT Gateway. It is created from the VPC subnets using the variable public_subnets_cidr_blocks.
#
resource "aws_eip" "nat_eip" {

}

#
# Creates the NAT Gateway in the VPC subnets using the variable public_subnets_cidr_blocks, and associate the EIP created above.
#
resource "aws_nat_gateway" "nat" {

}



#
# Creates private subnets using the variable private_subnets_cidr_blocks for CIDR definition.
#
resource "aws_subnet" "private_subnet" {

}

#
# Creates private route table for all private subnets to route internet traffic to the NAT Gateway.
#
resource "aws_route_table" "private_route_table" {

}

#
# Creates a route to the NAT Gateway for egress traffic from the private subnets.
#
resource "aws_route" "private_route_internet" {

}

#
# Associates of private route table with private subnets.
#
resource "aws_route_table_association" "private_route_table_association" {

}

#
# Creates public subnets using the variable public_subnets_cidr_blocks for CIDR definition.
#
resource "aws_subnet" "public_subnet" {

}

#
# Creates public route table for all public subnets to route internet traffic to the Internet Gateway.
#
resource "aws_route_table" "public_route_table" {

}

#
# Creates a route to the Internet Gateway for Internet traffic from the public subnets.
#
resource "aws_route" "public_route_internet" {

}

#
# Associates of public route table with public subnets.
#
resource "aws_route_table_association" "public_route_table_association" {

}




