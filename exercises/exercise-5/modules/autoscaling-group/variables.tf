#
# Module's input variables
#
variable "ami_id" {
  description = "AMI of the EC2 instance. Optional, pulls latest linux AMI by default."
  type        = string
}

variable "vpc" {
  description = "VPC of the autoscaling group."
  type        = string
}

variable "instance_type" {
  description = "Type of the instance"
  type        = string
  default     = "t3.micro"
}

variable "subnets" {
  description = "Subnet in which the instance will be deployed"
  type        = list(string)
}

variable "asg_security_groups" {
  description = "List of security group id(s) to which autoscaling group should be attached"
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "User data of the instance"
  type        = string
  default     = ""
}

