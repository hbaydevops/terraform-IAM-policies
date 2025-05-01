
resource "aws_iam_policy" "deny_privilege_escalation" {
    name        = "Webforx-PreventPrivilegeEscalation"
    description = "Denies permissions known to allow privilege escalation"
    policy      = file("${path.module}/policies/deny_priv_escalation.json")
  }
// resource "aws_iam_policy" "deny_privilege_escalation" {
//     name        = "Webforx-PreventPrivilegeEscalation"
//     description = "Denies permissions known to allow privilege escalation"
//     policy      = file("${path.module}/policies/deny_priv_escalation.json")
//   }
  