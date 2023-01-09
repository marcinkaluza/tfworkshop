#
# Creates an internal load balancer in the existing VPC subnets
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
#
resource "aws_lb" "load_balancer" {
  name               = "web-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnets
}

# Creates a target group to attach to the load balancer, accessible on port HTTP:80 and located in the existing VPC
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
#
resource "aws_lb_target_group" "target_group" {
  name     = "web-nlb-target-group"
  vpc_id   = var.vpc
  port     = 80
  protocol = "TCP"
}

# Creates a listener for the load balancer to listen on port TCP:80, with a default action to forward to its target group
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
#
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_iam_role" "asg_iam_role" {
  name_prefix = "asg-iam-role-"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

data "aws_iam_policy" "ssm" {
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.asg_iam_role.name
  policy_arn = data.aws_iam_policy.ssm.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name_prefix = "asg_instance_profile_"
  role        = aws_iam_role.asg_iam_role.name
}


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
