resource "aws_iam_policy" "Webforx-AllowIAMManagement" {
    name        = "Webforx-AllowIAMManagement"
    description = "Allows IAM permissions except user/group creation"
  
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "AllowIAMManagement"
          Effect = "Allow"
          Action = [
            "iam:Get*",
            "iam:List*",
            "iam:AttachRolePolicy",
            "iam:DetachRolePolicy",
            "iam:PutRolePolicy",
            "iam:DeleteRolePolicy",
            "iam:CreateRole",
            "iam:DeleteRole",
            "iam:UpdateAssumeRolePolicy",
            "iam:PassRole"
          ]
          Resource = "*"
        }
      ]
    })
  }
  