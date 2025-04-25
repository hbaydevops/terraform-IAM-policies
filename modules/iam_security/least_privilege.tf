resource "aws_iam_policy" "least_privilege" {
    name        = "Webforx-LeastPrivilege"
    description = "Grants minimal permissions"
    policy      = file("${path.module}/policies/least_privilege.json")
  }
  