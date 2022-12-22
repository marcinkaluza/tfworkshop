#
# Create outputs here
#
output "iam_arn" {
  description = "ARN of ASG EC2 IAM role"
  value       = aws_iam_role.asg_iam_role.arn
}

# Refer to Attributes Reference section of the documentation :
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
#
output "nlb_dns" {

}