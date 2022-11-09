#
# Creating the EventBridge rule (N.B: EventBridge was formerly known as Cloudwatch Event. The functionality are identical)
#
resource "aws_cloudwatch_event_rule" "rule" {
  name_prefix = var.rule_name_prefix
  description = "Event to automatically start the pipeline when a change occurs in the AWS CodeCommit source repository and branch. Deleting this may prevent changes from being detected in that pipeline. Read more: http://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-about-starting.html"
  event_pattern = jsonencode(
    {
      source      = ["aws.codecommit"]
      detail-type = ["CodeCommit Repository State Change"]
      resources   = ["${var.repo_arn}"]
      detail = {
        event         = ["referenceCreated", "referenceUpdated"]
        referenceType = ["branch"]
        referenceName = [var.branch_name]
      }
  })
}

#
# Defining rule target
#
resource "aws_cloudwatch_event_target" "target" {
  rule      = aws_cloudwatch_event_rule.rule.name
  target_id = "TriggerCodePipeline"
  arn       = var.codepipeline_arn
  role_arn  = aws_iam_role.role.arn
}

#
# Creating IAM role to associate to the target
#
resource "aws_iam_role" "role" {
  name_prefix = "${var.rule_name_prefix}role_"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Principal = {
            Service = "events.amazonaws.com"
          }
          Effect = "Allow"
        }
      ]
  })

}

#
# Creating IAM policy document to associate to the role
#
data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = ["codepipeline:StartPipelineExecution"]
    resources = ["${var.codepipeline_arn}"]
  }
}

#
# Creating the IAM policy to associate to the role
#
resource "aws_iam_role_policy" "policy" {
  name   = "start_code_pipeline"
  policy = data.aws_iam_policy_document.policy.json
  role   = aws_iam_role.role.name
}

