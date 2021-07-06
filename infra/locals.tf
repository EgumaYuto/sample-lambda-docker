locals {
  name       = "lambda-docker"
  account_id = data.aws_caller_identity.identity.account_id
  region     = "ap-northeast-1"
}