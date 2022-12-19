#
# Module's input variables
#
variable "name" {
  description = "Name of the EC2 instance."
  type        = string
  default     = "EC2"
}

variable "ami_id" {
  description = "AMI of the EC2 instance. Optional, pulls latest linux AMI by default."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Type of the instance"
  type        = string
  default     = "t3.micro"  
}

variable "subnet_id" {
  description = "Subnet in which the instance will be deployed"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group id(s) to which EC2 should be attached"
  type        = list(string)
  default     = []
}

variable "public_ip" {
  description = "Associate a public IP to the instance"
  type        = string 
  default     = "false"  
}

variable "user_data" {
  description = "User data of the instance"
  type        = string  
  default     = ""
}

