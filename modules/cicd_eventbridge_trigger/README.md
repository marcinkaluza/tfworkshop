# What is this module for?
This module creates event bridge rule to start CodePipeline on commit in CodeCommit repository.

# How do I use it?
Simple usage:

<code>
module "trigger" { <br>
  &nbsp; source           = "../cicd_eventbridge_trigger" <br>
  &nbsp; repo_arn         = aws_codecommit_repository.infra_repo.arn <br>
  &nbsp; codepipeline_arn = aws_codepipeline.codepipeline.arn <br>
  &nbsp; rule_name_prefix = "${aws_codepipeline.codepipeline.name}_trigger_" <br>
}
</code>
<br>
<br>

# Inputs
|Variable name|Required|Description|
|-------------|--------|-----------|
|repo_arn|Yes|ARN of the code commit repository|
|codepipeline_arn|Yes|ARN of the code pipeline to execute on commit|
|rule_name_prefix|Yes|Prefix of the name for the EventBridge rule to be generated|
|branch_name|No|Name of the branch to track (**main** will be used if not specified)|
# Outputs
None

# Ignored checkov warnings
None