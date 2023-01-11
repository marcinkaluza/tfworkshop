# Creates launch configuration for the autoscaling group, with same arguments as for the Bastion EC2 instance
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration
#
resource "aws_launch_configuration" "launch_configuration" {
  image_id             = var.ami_id
  user_data            = var.user_data
  instance_type        = var.instance_type
  security_groups      = var.asg_security_groups
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
  name                      = "web-server-asg"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.launch_configuration.name
  vpc_zone_identifier       = var.subnets
  target_group_arns         = [aws_lb_target_group.target_group.arn]
}

# Autoscaling policy for the ASG
# Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy
#
resource "aws_autoscaling_policy" "example" {
  name                   = "web-server-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 30.0
  }
}
