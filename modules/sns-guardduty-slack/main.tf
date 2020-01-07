# -----------------------------------------------------------
# Create IAM Role for SNS Slack lambda
# -----------------------------------------------------------

resource "aws_iam_role" "sns_slack_lambda_role" {
  name = var.sns_slack_lambda_role

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# -----------------------------------------------------------
# Create policy for CloudWatch Event - SNS
# -----------------------------------------------------------

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.guardduty_sns.arn]
  }
}

# -----------------------------------------------------------
# Attach Policy to SNS
# -----------------------------------------------------------

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.guardduty_sns.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

# -----------------------------------------------------------
# Create policy for logging
# -----------------------------------------------------------

resource "aws_iam_policy" "sns_slack_lambda_logging" {
  name        = var.sns_slack_lambda_logging
  description = "IAM policy for logging from sns slack lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# -----------------------------------------------------------
# Attach Logging Policy to SNS Slack Lambda role
# -----------------------------------------------------------

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.sns_slack_lambda_role.name
  policy_arn = aws_iam_policy.sns_slack_lambda_logging.arn
}

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_slack_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.guardduty_sns.arn
}

# -----------------------------------------------------------
# set up AWS sns topic and subscription
# -----------------------------------------------------------

resource "aws_sns_topic" "guardduty_sns" {
  name = "guardduty-sns-lambda"
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = aws_sns_topic.guardduty_sns.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.sns_slack_lambda.arn
}

# -----------------------------------------------------------
# Collect SSM Parameters
# -----------------------------------------------------------

data "aws_ssm_parameter" "slack_channel" {
  name = var.ssm_slack_channel
}

data "aws_ssm_parameter" "slack_incoming_webhook" {
  name = var.ssm_slack_incoming_webhook
}

# -----------------------------------------------------------
# set up AWS Cloudwatch Event to target an sns topic event rule
# -----------------------------------------------------------

resource "aws_cloudwatch_event_target" "main" {
  rule = var.event_rule
  arn  = aws_sns_topic.guardduty_sns.arn
}

resource "aws_lambda_function" "sns_slack_lambda" {
  filename         = var.filename
  function_name    = var.lambda_function_name
  role             = aws_iam_role.sns_slack_lambda_role.arn
  handler          = "sns_guardduty_slack.lambda_handler"
  source_code_hash = base64sha256(var.filename)
  runtime          = "python3.7"

  environment {
    variables = {
      SLACK_CHANNEL = data.aws_ssm_parameter.slack_channel.value
      HOOK_URL      = data.aws_ssm_parameter.slack_incoming_webhook.value
    }
  }
}

resource "aws_cloudwatch_log_group" "sns_slack_lambda_log" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}
