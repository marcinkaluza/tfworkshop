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
  count = length(var.public_subnets_cidr_blocks)
  vpc   = true
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.public_subnets_cidr_blocks)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
}

