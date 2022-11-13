#
# Build of the code
#
module "lambda_build" {
  source              = "../codebuild"
  codebuild_role      = aws_iam_role.codebuild-role.arn
  buildspec_file_name = "buildspec.yml"
  project_name        = "${var.function_name}-build"
}

#
# Deployment build buidlspec
#
data "template_file" "buildspec" {
  template = "${file("${path.module}/deployment.yml")}"
  vars = {
    function_name = var.function_name
    code_bucket = module.code_bucket.name
  }
}

#
# Deployment build
#
module "lambda_deployment" {
  source              = "../codebuild"
  codebuild_role      = aws_iam_role.codebuild-role.arn
  buildspec_file_name = data.template_file.buildspec.rendered
  project_name        = "${var.function_name}-deployment"
}



