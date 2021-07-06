resource "aws_apigatewayv2_api" "api" {
  name          = local.name
  protocol_type = "HTTP"
  target        = aws_lambda_function.function.arn
}

resource "aws_lambda_permission" "apigw" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}