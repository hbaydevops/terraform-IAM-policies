output "naming_policy_arn" {
    value = aws_organizations_policy.naming_policy.arn
  }
  
  output "region_restriction_arn" {
    value = aws_organizations_policy.region_restriction.arn
  }
  