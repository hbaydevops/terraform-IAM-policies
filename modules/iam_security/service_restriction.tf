resource "aws_organizations_policy" "service_restriction" {
    name        = "Webforx-ServiceRestriction"
    description = "Allow only specific AWS services"
    content     = jsonencode({
      Version = "2012-10-17",
      Statement = [{
        Sid      = "DenyUnapprovedServices",
        Effect   = "Deny",
        Action   = "*",
        Resource = "*",
        Condition = {
          StringNotEqualsIfExists = {
            "aws:ServiceName" = ["ec2.amazonaws.com", "s3.amazonaws.com"]
          }
        }
      }]
    })
  }
  