# outputs.tf
output "kke_dynamodb_table" {
  description = "Name of the DynamoDB table provisioned."
  value       = aws_dynamodb_table.datacenter_table.name
}


output "kke_iam_role_name" {
  description = "Name of the IAM role provisioned."
  value       = aws_iam_role.datacenter_role.name
}


output "kke_iam_policy_name" {
  description = "Name of the IAM policy provisioned."
  value       = aws_iam_policy.datacenter_readonly_policy.name
}