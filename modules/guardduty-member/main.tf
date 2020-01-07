# -----------------------------------------------------------
# enable member aws guard duty
# -----------------------------------------------------------

resource "aws_guardduty_detector" "member" {
  enable                       = true
  finding_publishing_frequency = var.publish_frequency
}

# -----------------------------------------------------------
# accept invitation from master aws guard duty
# -----------------------------------------------------------

resource "aws_guardduty_invite_accepter" "member" {
  detector_id       = aws_guardduty_detector.member.id
  master_account_id = var.master_account_id
}

# -----------------------------------------------------------
# set up AWS Cloudwatch Event rule for Guardduty Findings
# also to set up an event pattern (json file)
# -----------------------------------------------------------

resource "aws_cloudwatch_event_rule" "main" {
  name        = "guardduty-finding-events"
  description = "AWS GuardDuty event findings"

  event_pattern = <<PATTERN
{
  "detail-type": [
    "GuardDuty Finding"
  ],
  "source": [
    "aws.guardduty"
  ],
  "detail": {
    "severity": [
      7,
      7.0,
      7.1,
      7.2,
      7.3,
      7.4,
      7.5,
      7.6,
      7.7,
      7.8,
      7.9,
      8,
      8.0,
      8.1,
      8.2,
      8.3,
      8.4,
      8.5,
      8.6,
      8.7,
      8.8,
      8.9
    ]
  }
}
PATTERN
}
