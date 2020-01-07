# AWS GuardDuty master

This module would enable GuardDuty in the selected account. You can link other AWS GuardDuty to this one by using the exported values

# Installation

This module is controlled and deployed by Terraform, just indicate the source module in the root of this repository.

# Usage

As an example, lets enable GuardDuty:

```hcl
module "aws_guardduty_master" {
  source = "modules/guardduty-master"

  providers = {
    aws = "aws.main"
  }
}
```

***Notes***

You can link other accounts to AWS GuardDuty by implementing following modules:
- [GuardDuty invitations](../guardduty-invitation)
- [GuardDuty members](../guardduty-member)

# Deployment

As explained previously, this module is deployed by Terraform. This repository is leveraging AWS CodePipeline to access and deploy in multiple AWS Account.
