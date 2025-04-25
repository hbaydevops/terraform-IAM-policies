resource "aws_iam_policy" "deny_bare_metal" {
    name        = "Webforx-DenyBareMetal"
    description = "Denies launch of EC2 bare metal instances"
    policy      = jsonencode({
      Version = "2012-10-17",
      Statement = [{
        Sid      = "DenyBareMetalInstances",
        Effect   = "Deny",
        Action   = "ec2:RunInstances",
        Resource = "*",
        Condition = {
          StringEquals = {
            "ec2:InstanceType" = [
              "i3.metal", "c5.metal", "u-6tb1.metal"
            ]
          }
        }
      }]
    })
  }
  