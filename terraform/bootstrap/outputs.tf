output "state_bucket_name" {
  description = "S3 bucket name for Terraform state"
  value       = aws_s3_bucket.tfstate.id
  sensitive   = true
}

output "state_bucket_arn" {
  description = "S3 bucket ARN for Terraform state"
  value       = aws_s3_bucket.tfstate.arn
  sensitive   = true
}

output "lock_table_name" {
  description = "DynamoDB table name for state locking"
  value       = aws_dynamodb_table.tflock.name
  sensitive   = true
}

output "aws_account_id" {
  description = "AWS account ID"
  value       = local.account_id
  sensitive   = true
}
