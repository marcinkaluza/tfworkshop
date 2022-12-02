#
# Module's input variables
#
variable "user_name" {
  description = "Name of the user account"
  type        = string
}

variable "password" {
  description = "Password of the user account"
  type        = string
}

variable "cluster_name" {
  description = "Name of the memory DB cluster"
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids"
}

variable "security_group_ids" {
  type        = list(string)
  description = "IDs of the security groups to be used by the cluster"
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS encryption key to be used to encrypt data at rest"
}

variable "num_shards" {
  type        = number
  description = "Number of shards"
  default     = 1
}

variable "node_type" {
  type        = string
  description = "Type of the EC2 instance to be used for nodes"
  default     = "db.t4g.small"
}

