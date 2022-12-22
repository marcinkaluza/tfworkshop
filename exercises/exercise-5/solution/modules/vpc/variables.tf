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

variable "allow_internet_egress" {
  type        = bool
  description = "Set to true to allow internet egress from private subnets"
  default     = true
}