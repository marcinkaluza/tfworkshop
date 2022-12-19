#
# Create outputs here
#
output "alb_dns" {
  description = "DNS of the load balancer"
  value       = aws_lb.load_balancer.dns_name
}

output "iam_arn" {
  description = "ARN of ASG EC2 IAM role"
  value       = aws_iam_role.asg_iam_role.arn
}