variable "lambda_function_name" {
  default = "guardduty-sns-slack"
}

variable "filename" {
  default = "guardduty-sns-slack-payload.zip"
}

variable "event_rule" {}

variable "sns_slack_lambda_role" {
  default = "guardduty-sns-lambda-role"
}

variable "sns_slack_lambda_logging" {
  default = "sns-lambda-logging-policy"
}

variable "ssm_slack_incoming_webhook" {}

variable "ssm_slack_channel" {}
