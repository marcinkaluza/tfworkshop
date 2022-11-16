#
# Account setttings to enable logging
#
resource "aws_api_gateway_account" "api" {
  cloudwatch_role_arn = aws_iam_role.role.arn
}

#
# Role for cloudwatch access
#
resource "aws_iam_role" "role" {
  name = "api_gateway_cloudwatch_role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Principal = {
            Service = "apigateway.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
  })
}

#
# Policy document
#
data "aws_iam_policy_document" "policy" {
  #checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = ["*"]
  }
}

#
# Policy allowing acess to cloudwatch
#
resource "aws_iam_role_policy" "cloudwatch" {
  name   = "Cloudwatch_acess"
  role   = aws_iam_role.role.id
  policy = data.aws_iam_policy_document.policy.json
}