variable "main_aws_account_id" {
  default = "100000000000"
}

variable "member_aws_account_id" {
  default = "123456789012"
}

variable "ssm_slack_channel" {
  default = "/root/slack/channel"
}

variable "ssm_slack_incoming_webhook" {
  default = "/root/slack/incoming-webhook"
}

variable "ssm_email_member_parameter" {
  default = "/root/email"
}
