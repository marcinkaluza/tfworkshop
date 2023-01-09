#
# Creates an internal load balancer in the existing VPC subnets
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
#
resource "aws_lb" "load_balancer" {
  # Set following properties of the load balancer:
  # name
  # internal (set to true)
  # type of load balancer needs to be set to "network"
  # subnets argument needs to be provided and set to 
  # the value of the corresponding variable
}

# Creates a target group to attach to the load balancer, accessible on port HTTP:80 and located in the existing VPC
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
#
resource "aws_lb_target_group" "target_group" {
  # Following arguments are required:
  # name
  # id of the vpc
  # port (set to 80)
  # protocol set to "TCP"
}

# Creates a listener for the load balancer to listen on port TCP:80, with a default action to forward to its target group
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
#
resource "aws_lb_listener" "listener" {
  # Following arguments required:
  # ARN of the load balancer
  # port (set to 80)
  # protocol (set to "TCP")

  # Forward all traffic to the target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# Creates launch configuration for the autoscaling group, with same arguments as for the Bastion EC2 instance
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration
#
resource "aws_launch_configuration" "launch_configuration" {
  # Following arguments are required 
  # All arguments have corresponding variables
  # Id of the AMI
  # user_data for the instance
  # instance_type
  # security groups
  
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  lifecycle {
    create_before_destroy = true
  }
}

# Creates an autoscaling group based on the launch configuration created above. Subnets are the same as from the existing VPC
# The size should be between 1 and 3 instances.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
#
resource "aws_autoscaling_group" "asg" {
  # Following arguments are required:
  # name
  # max size of the autoscaling group (set to 5)
  # min size of the autoscaling group (set to 1)
  # health check grace period (set to 300)
  # health check type (set to "ELB")
  # desired capacity (set to 1)
  # force delete (set to True)
  launch_configuration      = aws_launch_configuration.launch_configuration.name
  vpc_zone_identifier       = var.subnets
  target_group_arns         = [aws_lb_target_group.target_group.arn]
}

# Autoscaling policy for the ASG
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy
#
resource "aws_autoscaling_policy" "example" {
  name                   = "web-server-cpu-policy"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 30.0
  }
}
