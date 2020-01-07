# -----------------------------------------------------------
# Enable AWS GuardDuty in Main AWS account
# -----------------------------------------------------------
module "aws_guardduty_master" {
  source = "modules/guardduty-master"

  providers = {
    aws = "aws.main"
  }
}

# -----------------------------------------------------------
# Enable AWS GuardDuty SNS Notification to Slack
# -----------------------------------------------------------

module "aws_guardduty_sns_notifications" {
  source = "modules/sns-guardduty-slack"

  providers = {
    aws = "aws.main"
  }

  event_rule                 = module.aws_guardduty_master.guardduty_event_rule
  ssm_slack_channel          = var.ssm_slack_channel
  ssm_slack_incoming_webhook = var.ssm_slack_incoming_webhook
}

# -----------------------------------------------------------
# Send AWS GuardDuty invitations to members
# -----------------------------------------------------------

module "aws_guardduty_invite_member" {
  source = "modules/guardduty-invitation"

  providers = {
    aws = "aws.main"
  }

  detector_master_id     = module.aws_guardduty_master.guardduty_master_id
  email_member_parameter = var.email_member_parameter_member
  member_account_id      = var.member_aws_account_id
}

# -----------------------------------------------------------
# Enable AWS GuardDuty in Member AWS account
# -----------------------------------------------------------

module "aws_guardduty_member" {
  source = "modules/guardduty-member"

  providers = {
    aws = "aws.member"
  }

  master_account_id = var.main_aws_account_id
}
