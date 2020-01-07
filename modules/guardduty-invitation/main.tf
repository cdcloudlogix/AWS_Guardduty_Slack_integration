# -----------------------------------------------------------
# Collect ssm parameters containing email information
# -----------------------------------------------------------

data "aws_ssm_parameter" "email" {
  name = var.email_member_parameter
}

# -----------------------------------------------------------
# send invitation to member(s) aws guard duty
# -----------------------------------------------------------

resource "aws_guardduty_member" "members" {
  account_id         = var.member_account_id
  email              = data.aws_ssm_parameter.email.value
  detector_id        = var.detector_master_id
  invite             = true
  invitation_message = "please accept guardduty invitation"
}
