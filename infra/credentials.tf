 resource "aws_ssm_parameter" "slack_api_token" {
   name  = "token"
   type  = "SecureString"
   value = "dummy"

   lifecycle {
     ignore_changes = [value]
   }
 }