#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target#argument-reference
resource "aws_cloudwatch_event_target" "example" {
  arn  = aws_lambda_function.example.arn
  rule = aws_cloudwatch_event_rule.example.id

  input_transformer {
    input_paths = {
      instance = "$.detail.instance",
      status   = "$.detail.status",
    }
    input_template = <<EOF
{
  "instance_id": <instance>,
  "instance_status": <status>
}
EOF
  }
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule#argument-reference
resource "aws_cloudwatch_event_rule" "console" {
  name        = "capture-aws-sign-in"
  description = "Capture each AWS Console Sign In"

  event_pattern = jsonencode({
    detail-type = [
      "AWS Console Sign In via CloudTrail"
    ]
  })
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group#argument-reference
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/"
  retention_in_days = 30
}
