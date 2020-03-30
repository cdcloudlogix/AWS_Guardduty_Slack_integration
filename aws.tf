terraform {
  required_version = "~> 0.12.0"

  backend "s3" {
    acl     = "bucket-owner-full-control"
    bucket  = "tf-state-bucket-guardduty"
    encrypt = true
    key     = "aws.tfstate"
    region  = "eu-west-1"
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.6"
}

provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.6"
  alias   = "main"

  profile = "default"
}

provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.6"
  alias   = "member"

  profile = "member"
}
