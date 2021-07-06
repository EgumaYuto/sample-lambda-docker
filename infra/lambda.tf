resource "aws_lambda_function" "function" {
  function_name = local.name
  role          = aws_iam_role.role.arn
  package_type  = "Image"
  image_uri     = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/lambda-docker@sha256:50685ac4a6cb126153962d9103e0347de8d35545346468605b4b9c63be6014c5"
  timeout       = 60

  lifecycle {
    ignore_changes = [image_uri]
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