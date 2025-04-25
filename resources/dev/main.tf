provider "aws" {
    region = var.region
  }
  
  module "iam_security" {
    source = "../../modules/iam_security"

  }
  