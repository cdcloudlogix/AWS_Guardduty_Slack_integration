# AWS GuardDuty invitation

This module would enable to link AWS GuardDuty master with its members.

# Installation

This module is controlled and deployed by Terraform, just indicate the source module in the root of this repository.

# Usage

As an example, lets send invitation to link AWS GuardDuty master with a member:

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

***Notes***

You would also need to deploy [GuardDuty Master](../guardduty-master), call this module and then deploy a [GuardDuty member](../guardduty-member). This module requires GuardDuty master ID and the root AWS account email address.

# Deployment

As explained previously, this module is deployed by Terraform. This repository is leveraging AWS CodePipeline to access and deploy in multiple AWS Accounts.
