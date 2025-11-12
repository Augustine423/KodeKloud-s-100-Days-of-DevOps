# Create IAM policy for EC2 read-only access
resource "aws_iam_policy" "iampolicy_mark" {
  name        = "iampolicy_mark"
  description = "Read-only access to EC2 console: view instances, AMIs, and snapshots"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeImages",
                "ec2:DescribeSnapshots"
        ]
        Resource = "*"
      }
    ]
  })
}

