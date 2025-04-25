resource "aws_organizations_policy" "region_restriction" {
    name        = "Webforx-RegionRestriction"
    description = "Deny operations outside us-east-1"
    content     = jsonencode({
      Version = "2012-10-17",
      Statement = [{
        Sid      = "DenyNotUSEast1",
        Effect   = "Deny",
        Action   = "*",
        Resource = "*",
        Condition = {
          StringNotEqualsIfExists = {
            "aws:RequestedRegion" = "us-east-1"
          }
        }
      }]
    })
  }
  