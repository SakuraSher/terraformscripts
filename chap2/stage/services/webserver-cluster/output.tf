output "s3_bucket_arn"{
  value = aws_s3_bucket.terraform_state.arn
  description = "State of S3 bucket"
}

output "dynamodb_table_name"{
  value = aws_dynamodb_table.terraform-locks.name
  description ="dynamodb_table_name"
}
