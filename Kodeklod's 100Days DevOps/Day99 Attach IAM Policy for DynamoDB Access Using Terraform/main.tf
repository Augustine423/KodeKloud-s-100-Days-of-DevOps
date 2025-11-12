# main.tf
resource "aws_dynamodb_table" "datacenter_table" {
  name           = var.KKE_TABLE_NAME
  billing_mode   = "PAY_PER_REQUEST" 
  hash_key       = "id"
  
  attribute {
    name = "id"
    type = "S"
  }
}


resource "aws_iam_role" "datacenter_role" {
  name = var.KKE_ROLE_NAME
  

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      },
    ],
  })
}


resource "aws_iam_policy" "datacenter_readonly_policy" {
  name = var.KKE_POLICY_NAME

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
        ],
        Effect   = "Allow",
        Resource = aws_dynamodb_table.datacenter_table.arn, 
      },
    ],
  })
}


resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.datacenter_role.name 
  policy_arn = aws_iam_policy.datacenter_readonly_policy.arn 
}