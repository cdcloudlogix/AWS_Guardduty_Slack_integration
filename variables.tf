provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.6"
}

variable "main_aws_account_id" {
  default = "100000000000"
}

variable "member_aws_account_id" {
  default = "123456789012"
}
