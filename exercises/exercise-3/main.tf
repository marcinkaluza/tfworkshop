data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

#
# The VPC
#
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.name
  }
}

#
# Default security group withg no rules 
#
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id
}

#
# Internet gateway
#
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

#
# NA gateway AZ
# NOTE: It a requirement as per AWS Securiy Matrix have a NAT per AZ
#
resource "aws_eip" "nat_eip" {
  vpc   = true
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.public_subnet.id
  allocation_id = aws_eip.nat_eip.id
}



#
# Private subnet
#
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets_cidr_blocks)

  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnets_cidr_blocks, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "Private subnet ${count.index + 1}"
  }
}

#
# Private route table for each subnet as we are routing internet traffic 
# to a NAT in the same AZ as the subnet.
#
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Private Route Table"
  }
}

#
# Route to the internet - different for each AZ/NAT gateway
#
resource "aws_route" "private_route_internet" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

#
# Association of route table with private subnet 
#
resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

#
# Public subnets
#
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnets_cidr_blocks)

  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnets_cidr_blocks, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "Public subnet ${count.index + 1}"
  }
}

#
# Single route table for all public subnets
#
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "PublicRouteTable"
  }
}

#
# Route to the internet throguh IGW
#
resource "aws_route" "public_route_internet" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#
# Association of the route table to all public subnets
#
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}



