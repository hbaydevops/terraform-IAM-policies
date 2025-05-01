
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
  

resource "aws_iam_role" "webforx_policy_tester-02" {
  name = "webforx-policy-tester-02"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::490004630776:root"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags  # Add the tags here
}

resource "aws_iam_policy" "webforx_tester_policy" {
  name        = "WebforxPolicyTester-02"
  description = "Policy for testing IAM restrictions in Webforx module"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid     = "AllowBasicReadOnlyS3",
        Effect  = "Allow",
        Action  = ["s3:GetObject", "s3:ListAllMyBuckets"],
        Resource = ["arn:aws:s3:::*", "arn:aws:s3:::*/*"]
      },
      {
        Sid     = "AllowTagging",
        Effect  = "Allow",
        Action  = ["ec2:CreateTags", "rds:AddTagsToResource", "tag:TagResources", "tag:GetResources"],
        Resource = "*"
      },
      {
        Sid     = "DenyMissingTags",
        Effect  = "Deny",
        Action  = ["ec2:RunInstances", "ec2:CreateVolume", "rds:CreateDBInstance"],
        Resource = "*",
        Condition = {
          Null = {
            "aws:TagKeys" = "true"
          }
        }
      },
      {
        Sid     = "DenyIAMChanges",
        Effect  = "Deny",
        Action  = ["iam:Create*", "iam:Delete*", "iam:Put*", "iam:Update*", "iam:Add*", "iam:Remove*"],
        Resource = "*"
      },
      {
        Sid     = "AllowIAMManagement",
        Effect  = "Allow",
        Action  = [
          "iam:Get*", "iam:List*", "iam:AttachRolePolicy", "iam:DetachRolePolicy", "iam:PutRolePolicy", 
          "iam:DeleteRolePolicy", "iam:CreateRole", "iam:DeleteRole", "iam:UpdateAssumeRolePolicy", "iam:PassRole"
        ],
        Resource = "*"
      },
      {
        Sid     = "AllowDescribeEC2",
        Effect  = "Allow",
        Action  = ["ec2:DescribeInstances", "ec2:DescribeRegions"],
        Resource = "*",
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = "us-east-1"
          }
        }
      },
      {
        Sid     = "AllowCloudWatchLogsRead",
        Effect  = "Allow",
        Action  = ["logs:GetLogEvents", "logs:DescribeLogGroups", "logs:DescribeLogStreams"],
        Resource = "*"
      },
      {
        Sid     = "DenyNonGP3OrLargeEBS",
        Effect  = "Deny",
        Action  = ["ec2:CreateVolume"],
        Resource = "*",
        Condition = {
          StringNotEquals = {
            "ec2:VolumeType" = "gp3"
          },
          NumericGreaterThan = {
            "ec2:VolumeSize" = 30
          }
        }
      },
      {
        Sid     = "DenyInvalidRDS",
        Effect  = "Deny",
        Action  = ["rds:CreateDBInstance"],
        Resource = "*",
        Condition = {
          StringNotEqualsIfExists = {
            "rds:Engine" = ["mysql", "postgres"]
          },
          NumericGreaterThanIfExists = {
            "rds:AllocatedStorage" = 30
          }
        }
      },
      {
        Sid     = "EnforceNaming",
        Effect  = "Deny",
        Action  = "*",
        Resource = "*",
        Condition = {
          StringNotLikeIfExists = {
            "aws:RequestTag/Name" = "webforx-*"
          }
        }
      },
      {
        Sid     = "ExplicitDenyIAMUserGroupActions",
        Effect  = "Deny",
        Action  = ["iam:CreateUser", "iam:DeleteUser", "iam:CreateGroup", "iam:DeleteGroup"],
        Resource = "*"
      },
      {
        Sid     = "AllowOnlyT2AndT3Instances",
        Effect  = "Allow",
        Action  = "ec2:RunInstances",
        Resource = "*",
        Condition = {
          StringLike = {
            "ec2:InstanceType" = ["t2.*", "t3.*"]
          },
          StringEquals = {
            "aws:RequestedRegion" = "us-east-1"
          }
        }
      },
      {
        Sid     = "DenyBareMetalInstanceTypes",
        Effect  = "Deny",
        Action  = "ec2:RunInstances",
        Resource = "*",
        Condition = {
          StringLike = {
            "ec2:InstanceType" = "*.metal"
          }
        }
      }
    ]
  })

  tags = var.tags  # Add the tags here
}

resource "aws_iam_role_policy_attachment" "attach_tester_policy" {
  role       = aws_iam_role.webforx_policy_tester-02.name
  policy_arn = aws_iam_policy.webforx_tester_policy.arn
}


