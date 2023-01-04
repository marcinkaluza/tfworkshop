variable "name" {
  type        = string
  description = "Name of the VPC"
}

variable "cidr_block" {
  type        = string
  description = "CIDR Block for the VPC"
}

variable "private_subnets_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
}

variable "public_subnets_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
}

variable "target_region" {
  type        = string
  description = "Target AWS region"
}
