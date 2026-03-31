output "dynamodb_table_arn" {
  value = aws_dynamodb_table.url_dynamodb.arn
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.url_dynamodb.name
}