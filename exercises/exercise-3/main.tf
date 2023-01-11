#
# Documentation: https://developer.hashicorp.com/terraform/language/modules/syntax
module vpc {
  source = "./modules/vpc"
  # TODO: Provide arguments
  # name
  # cidr block
  # public subnets cirdr block
  # private subnets cidr block
}