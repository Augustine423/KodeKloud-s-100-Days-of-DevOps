# Variables.tf
variable "KKE_TABLE_NAME" {
  description = "name of the DynamoDB table"
  type = string
}

variable "KKE_ROLE_NAME" {
  description = "name of the IAM role"
  type = string
}

variable "KKE_POLICY_NAME" {
  description = "name of the IAM policy"
  type = string
}