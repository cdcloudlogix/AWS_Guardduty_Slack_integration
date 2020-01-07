# AWS GuardDuty members

This module would enable GuardDuty in the selected account. This module would require to have the AWS account ID containing AWS Guardduty master.

# Installation

This module is controlled and deployed by Terraform, just indicate the source module in the root of this repository.

# Usage

As an example, lets enable GuardDuty and link it to master account:

```hcl
module "aws_guardduty_member_dev" {
  source                    = "modules/guardduty-member"

  providers = {
    aws = "aws.account"
  }

  master_account_id = var.main_aws_account_id
}
```

***Notes***

You would also need to deploy [GuardDuty Master](../guardduty-master) as well as sending [invitations](../guardduty-invitation) before deploying this module.

# Deployment

As explained previously, this module is deployed by Terraform. This repository is leveraging AWS CodePipeline to access and deploy in multiple AWS Account.
