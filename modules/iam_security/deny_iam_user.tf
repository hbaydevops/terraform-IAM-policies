
resource "aws_iam_policy" "deny_iam_user" {
    name        = "Webforx-DenyIAMUser"
    description = "Denies creation and deletion of IAM users"
    policy      = jsonencode({
      Version = "2012-10-17",
      Statement = [{
        Sid    = "DenyIAMUserCreateDelete",
        Effect = "Deny",
        Action = [
          "iam:CreateUser",
          "iam:DeleteUser"
        ],
        Resource = "*"
      }]
    })
}
resource "aws_iam_policy" "Webforx-DenyIAMUserGroupCreation" {
  name        = "Webforx-DenyIAMUserGroupCreation"
  description = "Denies IAM user creation and deletion"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyIAMUserGroupCreation"
        Effect = "Deny"
        Action = [
          "iam:CreateUser",
          "iam:DeleteUser",
          "iam:CreateGroup",
          "iam:DeleteGroup"
        ]
        Resource = "*"
      }
    ]
  })
}

