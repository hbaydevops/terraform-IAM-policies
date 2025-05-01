variable "region" {
    type        = string
    default     = "us-east-1"
    description = "Region to enforce for all operations"
  }
  
  variable "tags" {
    type = map(string)
    default = {
      "owner"          = "WEBFORX"
      "environment"    = "dev"
      "project"        = "Connect"
      "create_by"      = "Terraform"
      "cloud_provider" = "aws"
    }
    description = "Tags to apply to all AWS resources"
  }
  