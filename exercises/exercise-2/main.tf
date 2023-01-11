data "aws_availability_zones" "az" {}
#
# Creates a simple VPC using variable cidr_block and with DNS resolution enabled.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
#
resource "aws_vpc" "main" {
  # TODO: Add arguments to the VPC
  # cidr block (use cidr_block variable)
  # create Name tag with value taken from the "name" variable
}

#
# Creates a default security group withg no rules, associated to the VPC.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group
#
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 443
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#
# Creates an Internet gateway associated to the VPC.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
#
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
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
  count             = length(var.public_subnets_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.az.names[count.index]

  tags = {
    Name = "Public subnet ${count.index}"
  }
}

#
# Creates public route table for all public subnets to route internet traffic to the Internet Gateway.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
#
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Public route table"
  }
}

#
# Creates a route to the Internet Gateway for Internet traffic from the public subnets.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
#
resource "aws_route" "public_route_internet" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#
# Associates of public route table with public subnets.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
#
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.public_subnets_cidr_blocks)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

#
# Creates the NAT Gateway in the VPC subnets using the variable public_subnets_cidr_blocks, and associate the EIP created above.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
#
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "NAT gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

#
# Creates private subnets using the variable private_subnets_cidr_blocks for CIDR definition.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
#
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets_cidr_blocks)
  tags = {
    Name = "Private subnet ${count.index}"
  }
  #   TODO: Add required arguments:
  #   vpc id
  #   cidr block for the subnet
  #   availability zone
}

#
# Creates private route table for all private subnets to route internet traffic to the NAT Gateway.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
#
resource "aws_route_table" "private_route_table" {
  # TODO: Add required aruments:
  # vpc id
  # Name tag with value of "Private route table"
}

#
# Creates a route to the NAT Gateway for egress traffic from the private subnets.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
#
resource "aws_route" "private_route_internet" {
  nat_gateway_id = aws_nat_gateway.nat.id
  # TODO: Add required arguments
  # destination cidr block
  # route table id
}

#
# Associates of private route table with private subnets.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
#
resource "aws_route_table_association" "private_route_table_association" {
  count = length(var.private_subnets_cidr_blocks)
  # TODO : Add required arguments
  # subnet id
  # route table id
}






