# Creates launch configuration for the autoscaling group, with same arguments as for the Bastion EC2 instance
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration
#
resource "aws_launch_configuration" "launch_configuration" {
  # TODO: Provide required arguments
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
  # TODO: Provide required arguments
  # name
  # max size of the autoscaling group (set to 5)
  # min size of the autoscaling group (set to 1)
  # desired capacity (set to 1)
  # health check grace period (set to 300)
  # health check type (set to "ELB")
  # force delete (set to True)
  launch_configuration = aws_launch_configuration.launch_configuration.name
  vpc_zone_identifier  = var.subnets
  target_group_arns    = [aws_lb_target_group.target_group.arn]
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
