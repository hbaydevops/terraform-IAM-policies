resource "aws_iam_policy" "Webforx-DenyNonGP3OrLargeEBS" {
    name        = "Webforx-DenyNonGP3OrLargeEBS"
    description = "Denies non-gp3 EBS volumes or volumes larger than 30 GiB"
  
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "DenyNonGP3OrLargeEBS"
          Effect = "Deny"
          Action = [
            "ec2:CreateVolume"
          ]
          Resource = "*"
          Condition = {
            StringNotEquals = {
              "ec2:VolumeType" = "gp3"
            },
            NumericGreaterThan = {
              "ec2:VolumeSize" = 30
            }
          }
        }
      ]
    })
  }
  