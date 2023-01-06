data "aws_availability_zones" "az" {}
#
# Creates a simple VPC using variable cidr_block and with DNS resolution enabled.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
#
resource "aws_vpc" "main" {
}

#
# Creates a default security group withg no rules, associated to the VPC.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group
#
resource "aws_default_security_group" "default" {
}

#
# Creates an Internet gateway associated to the VPC.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
#
resource "aws_internet_gateway" "igw" {
}

#
# Creates an elastic IP (EIP) to associate to a NAT Gateway. It is created from the VPC subnets using the variable public_subnets_cidr_blocks.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
#
resource "aws_eip" "nat_eip" {
}

#
# Creates public subnets using the variable public_subnets_cidr_blocks for CIDR definition.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
#
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnets_cidr_blocks)
}

#
# Creates public route table for all public subnets to route internet traffic to the Internet Gateway.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
#
resource "aws_route_table" "public_route_table" {
}

#
# Creates a route to the Internet Gateway for Internet traffic from the public subnets.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
#
resource "aws_route" "public_route_internet" {
  gateway_id = aws_internet_gateway.igw.id
}

#
# Associates of public route table with public subnets.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
#
resource "aws_route_table_association" "public_route_table_association" {
  count = length(var.public_subnets_cidr_blocks)
}

#
# Creates the NAT Gateway in the VPC subnets using the variable public_subnets_cidr_blocks, and associate the EIP created above.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
#
# resource "aws_nat_gateway" "nat" {
# }

#
# Creates private subnets using the variable private_subnets_cidr_blocks for CIDR definition.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
#
# resource "aws_subnet" "private_subnet" {
#   count             = length(var.private_subnets_cidr_blocks)
# }

#
# Creates private route table for all private subnets to route internet traffic to the NAT Gateway.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
#
# resource "aws_route_table" "private_route_table" {
# }

#
# Creates a route to the NAT Gateway for egress traffic from the private subnets.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
#
# resource "aws_route" "private_route_internet" {
#   nat_gateway_id         = aws_nat_gateway.nat.id
# }

#
# Associates of private route table with private subnets.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
#
# resource "aws_route_table_association" "private_route_table_association" {
#   count          = length(var.private_subnets_cidr_blocks)
# }






