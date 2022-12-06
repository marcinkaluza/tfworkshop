#
# Module's input variables
#
variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group ids"
}

variable "kafka_version" {
  description = "Kafka version to use"
  type        = string
  default     = "3.3.1"
}

variable "instance_type" {
  type        = string
  description = "Type of the instance to be used for cluster nodes"
  default     = "kafka.m5.large"
}

variable "storage_size" {
  type        = number
  description = "Size of the storage in GiB"
  default     = 1000
}

variable "enhanced_monitoring_level" {
  type        = string
  description = "Level of enhanced moniutoring"
  default     = "PER_TOPIC_PER_PARTITION"
}
