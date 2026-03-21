resource "aws_dynamodb_table" "url_dynamodb" {
  name         = "${var.app_name}-table"
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }

}