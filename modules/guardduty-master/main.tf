# -----------------------------------------------------------
# enable master aws guard duty
# -----------------------------------------------------------

resource "aws_guardduty_detector" "master" {
  enable                       = true
  finding_publishing_frequency = var.publish_frequency
}

# -----------------------------------------------------------
# Output GuardDuty master id
# -----------------------------------------------------------

output "guardduty_master_id" {
  value = aws_guardduty_detector.master.id
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
      3,
      3.0,
      3.1,
      3.2,
      3.3,
      3.4,
      3.5,
      3.6,
      3.7,
      3.8,
      3.9,
      4,
      4.0,
      4.1,
      4.2,
      4.3,
      4.4,
      4.5,
      4.6,
      4.7,
      4.8,
      4.9,
      5,
      5.0,
      5.1,
      5.2,
      5.3,
      5.4,
      5.5,
      5.6,
      5.7,
      5.8,
      5.9,
      6,
      6.0,
      6.1,
      6.2,
      6.3,
      6.4,
      6.5,
      6.6,
      6.7,
      6.8,
      6.9,
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

# -----------------------------------------------------------
# Output GuardDuty cloudwatch id
# -----------------------------------------------------------

output "guardduty_event_rule" {
  value = aws_cloudwatch_event_rule.main.name
}
