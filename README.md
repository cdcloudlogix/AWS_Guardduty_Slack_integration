# AWS GuardDuty Slack Integration

This project is composed of several modules specialised in AWS Security components.

![Image](Guardduty.png?raw=true)

## Description

This Terraform repository would do the following:
* Enable AWS GuardDuty master
* Enable AWS Guardduty members
* Link AWS GuardDuty master with members
* Send findings to Slack


## Usage

Each terraform files at the root level of this project have specific function. As an example, lets enable Security AWS GuardDuty in the main AWS Account for alerting on various findings. We'll also invite and enable another aws accounts, and link it to AWS GuardDuty in the main AWS account.


### AWS GuardDuty master:

By calling `guardduty-master` module, this would enable AWS GuardDuty in the selected account, and outputs necessary variables for other terraform modules.

```hcl
module "aws_guardduty_master" {
  source                    = "modules/guardduty-master"

  providers = {
    aws = "aws.main"
  }
}
```

### AWS GuardDuty invitation:

After creating Guardduty Master, this module would send an invitation to its members. This module requires GuardDuty Master ID, the value exported from previous module.  

```hcl
module "aws_guardduty_invite_member" {
  source                    = "modules/guardduty-invitation"

  providers = {
    aws = "aws.main"
  }

  detector_master_id        = module.aws_guardduty_master.guardduty_master_id
  email_member_parameter    = var.email_member_parameter_member
  member_account_id         = var.member_aws_account_id
}
```

***Notes:*** `email_member_parameter` is the email address corresponding to the root account

### AWS GuardDuty members:

AWS GuardDuty member module would enable GuardDuty in the selected account, accept invitation from master and start sending event to GuardDuty Master.

```hcl
module "aws_guardduty_member_dev" {
  source = "modules/guardduty-member"

  providers = {
    aws = "aws.member"
  }

  master_account_id = var.main_aws_account_id
}
```

### AWS GuardDuty SNS notifications:

Final module, required module to send notifications to a selected Slack Channel.

```hcl
module "aws_guardduty_sns_notifications" {
  source = "modules/sns-guardduty-slack"

  providers = {
    aws = "aws.main"
  }

  event_rule                 = module.aws_guardduty_master.guardduty_event_rule
  ssm_slack_channel          = var.ssm_slack_channel
  ssm_slack_incoming_webhook = var.ssm_slack_incoming_webhook
}
```

## Prerequisites

Install:
- [Terraform](https://www.terraform.io/docs/)
- [Terraform IAM Role](https://github.com/ministryofjustice/analytical-platform-aws-security/tree/master/init-roles)


## Deployment

This project is using AWS CodePipeline to deploy modules in multiple AWS Accounts
