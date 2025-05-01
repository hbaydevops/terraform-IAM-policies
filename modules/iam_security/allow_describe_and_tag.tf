resource "aws_iam_policy" "Webforx-AllowDescribeAndTag" {
    name        = "Webforx-AllowDescribeAndTag"
    description = "Allows Describe and Tag actions globally"
  
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "AllowDescribeAndTag"
          Effect = "Allow"
          Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeVolumes",
          "ec2:CreateTags",
          "ec2:DescribeTags",
          "ec2:DescribeSecurityGroups",
          "ec2:ListTagsForResource",
          "rds:DescribeDBInstances",
          "rds:AddTagsToResource",
          "rds:DescribeDBClusters",
          "rds:ListTagsForResource",
          "tag:TagResources",
          "tag:GetResources"
  
          ]
          Resource = "*"
        }
      ]
    })
  }
  