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
