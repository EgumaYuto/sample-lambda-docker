resource "aws_lambda_function" "function" {
  function_name = local.name
  role          = aws_iam_role.role.arn
  package_type  = "Image"
  image_uri     = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/${local.name}:latest"
  timeout       = 60

  lifecycle {
    ignore_changes = [image_uri]
  }

  environment {
    variables = {
      SLACK_TOKEN_SSM_NAME = aws_ssm_parameter.slack_api_token.name
    }
  }
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "main" {
  statement {
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    effect    = "Allow"
    resources = ["${aws_cloudwatch_log_group.log_group.arn}:*"]
  }

  // TODO 本当は権限を絞るほうがいい
  statement {
    actions   = ["*"]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "role" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_policy" "policy" {
  name   = local.name
  policy = data.aws_iam_policy_document.main.json
}

resource "aws_iam_role_policy_attachment" "attachment" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.role.name
}

resource "aws_cloudwatch_log_group" "log_group" {
  retention_in_days = 3
  name              = "/aws/lambda/${local.name}"
}