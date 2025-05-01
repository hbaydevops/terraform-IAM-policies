resource "aws_iam_policy" "Webforx-DenyMissingTags" {
    name        = "Webforx-DenyMissingTags"
    description = "Denies creation of resources without required tags"
  
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "DenyMissingTags"
          Effect = "Deny"
          Action = [
            "ec2:RunInstances",
            "ec2:CreateVolume",
            "rds:CreateDBInstance"
          ]
          Resource = "*"
          Condition = {
            Null = {
              "aws:TagKeys" = "true"
            }
          }
        }
      ]
    })
  }
  