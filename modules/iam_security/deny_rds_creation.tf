resource "aws_iam_policy" "Webforx-DenyInvalidRDS" {
    name        = "Webforx-DenyInvalidRDS"
    description = "Denies RDS creation for unsupported engines and large storage"
  
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "DenyInvalidRDS"
          Effect = "Deny"
          Action = [
            "rds:CreateDBInstance"
          ]
          Resource = "*"
          Condition = {
            StringNotEqualsIfExists = {
              "rds:Engine" = ["mysql", "postgres"]
            },
            NumericGreaterThanIfExists = {
              "rds:AllocatedStorage" = 30
            }
          }
        }
      ]
    })
  }
  