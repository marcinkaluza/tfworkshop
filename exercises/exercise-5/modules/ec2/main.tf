data "aws_region" "current" {}

resource "aws_iam_role" "ec2_iam_role" {
  name_prefix = "ec2-iam-role-"

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
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = data.aws_iam_policy.ssm.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name_prefix = "instance_profile_"
  role        = aws_iam_role.ec2_iam_role.name
}


#
# Creates an EC2 instances of type t3.micro, with an instance profile for System Manager access,
# and living in a private subnet from existing VPC.
# Documentation : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
#
resource "aws_instance" "ec2" {
  # The definition needs to include:
  # ami id
  # subnet id
  # user data
  # instance type
  # tags including name
  # security group ids
  # instance profile

  ami                         = var.ami_id
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  user_data                   = var.user_data
  user_data_replace_on_change = true
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  tags = {
    Name = var.name
  }
}