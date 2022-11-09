#
# Creating the EventBridge rule (N.B: EventBridge was formerly known as Cloudwatch Event. The functionality are identical)
#
resource "aws_cloudwatch_event_rule" "cicd-infra-trigger" {
  name          = "cicd-infra-trigger"
  description   = "Event to automatically start your pipeline when a change occurs in the AWS CodeCommit source repository and branch. Deleting this may prevent changes from being detected in that pipeline. Read more: http://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-about-starting.html"
  event_pattern = <<EOF
{
  "source": ["aws.codecommit"],
  "detail-type": ["CodeCommit Repository State Change"],
  "resources": ["${var.infra_repo_arn}"], 
  "detail": {
    "event": ["referenceCreated", "referenceUpdated"],
    "referenceType": ["branch"],
    "referenceName": ["main"]
  }
}
EOF
}

#
# Defining rule target
#
resource "aws_cloudwatch_event_target" "cicd-infra-codepipeline" {
  rule      = aws_cloudwatch_event_rule.cicd-infra-trigger.name
  target_id = "TriggerCodePipeline"
  arn       = var.infra_codepipeline_arn
  role_arn  = aws_iam_role.event_target_start_infra_pipeline.arn
}

#
# Creating IAM role to associate to the target
#
resource "aws_iam_role" "event_target_start_infra_pipeline" {
  name               = "event_target_start_infra_pipeline"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

#
# Creating IAM policy document to associate to the role
#
data "aws_iam_policy_document" "event_target_start_infra_pipeline" {
  statement {
    effect    = "Allow"
    actions   = ["codepipeline:StartPipelineExecution"]
    resources = ["${var.infra_codepipeline_arn}"]
  }
}

#
# Creating the IAM policy to associate to the role
#
resource "aws_iam_policy" "event_target_start_infra_pipeline" {
  name   = "event_target_start_infra_pipeline"
  policy = data.aws_iam_policy_document.event_target_start_infra_pipeline.json
}

#
# Attaching IAM Policy to the role
#
resource "aws_iam_role_policy_attachment" "event_target_start_infra_pipeline" {
  role       = aws_iam_role.event_target_start_infra_pipeline.name
  policy_arn = aws_iam_policy.event_target_start_infra_pipeline.arn
}

