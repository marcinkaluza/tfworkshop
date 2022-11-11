variable "name_prefix" {
  type        = string
  description = "Prefix for the S3 Bucket's name, ensuring it's full name is unique"

}

variable "sse_algorithm" {
  type        = string
  description = "SSE algorithm. Possible values are aws:kms or AES256"
  default     = "aws:kms"
}

variable "log_bucket" {
  type = string
  description = "Target bucket for access logs (optional). If not provided, bucket will store log in itself"
  default = null
}

variable "access_policy" {
  type = string
  description = "Access policy for the bucket (in json)"
  default = null
}
 