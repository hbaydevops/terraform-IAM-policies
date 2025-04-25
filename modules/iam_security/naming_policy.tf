resource "aws_organizations_policy" "naming_policy" {
    name        = "Webforx-EnforceNaming"
    description = "Deny resource creation unless tagged with Name = webforx-*"
    content     = jsonencode({
      Version = "2012-10-17",
      Statement = [{
        Sid      = "EnforceNaming",
        Effect   = "Deny",
        Action   = "*",
        Resource = "*",
        Condition = {
          StringNotLikeIfExists = {
            "aws:RequestTag/Name" = "webforx-*"
          }
        }
      }]
    })
  }
  