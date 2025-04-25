resource "aws_iam_role" "webforx_policy_tester" {
    name = "webforx-policy-tester"
  
    assume_role_policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Principal = {
            AWS = "arn:aws:iam::<AWS-accountID>:root"
          },
          Action = "sts:AssumeRole"
        }
      ]
    })
  }
  
  resource "aws_iam_policy" "webforx_tester_policy" {
    name        = "WebforxPolicyTester"
    description = "Policy for testing IAM restrictions in Webforx module"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect   = "Allow",
          Action   = [
            "ec2:DescribeInstances",
            "ec2:RunInstances",
            "s3:ListAllMyBuckets",
            "s3:GetObject"
          ],
          Resource = "*",
          Condition = {
            StringEquals = {
              "aws:RequestedRegion" = "us-east-1"
            }
          }
        },
        {
          Sid    = "ExplicitDenyForIAMUser",
          Effect = "Deny",
          Action = [
            "iam:CreateUser",
            "iam:DeleteUser"
          ],
          Resource = "*"
        },
        {
          Sid    = "DenyBareMetal",
          Effect = "Deny",
          Action = "ec2:RunInstances",
          Resource = "*",
          Condition = {
            StringLike = {
              "ec2:InstanceType" = "*.metal"
            }
          }
        }
      ]
    })
  }
  
  resource "aws_iam_role_policy_attachment" "attach_tester_policy" {
    role       = aws_iam_role.webforx_policy_tester.name
    policy_arn = aws_iam_policy.webforx_tester_policy.arn
  }
  