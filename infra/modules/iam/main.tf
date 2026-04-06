resource "aws_iam_role" "execution_role" {
    name = var.execution_role_name

    assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action = "sts:AssumeRole"
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "execution_policy" {
  role = aws_iam_role.execution_role.name
  policy_arn = var.execution_policy_arn
}

resource "aws_iam_role" "task_role" {
    name = var.task_role_name

    assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action = "sts:AssumeRole"
      }
    ]
  })

}

# This data source simply creates the set of permissions for dynamodb
data "aws_iam_policy_document" "ecs_task_app" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    resources = [
      var.dynamodb_table_arn
    ]
  }
}

# attaching the task role to the dynamodb policy
resource "aws_iam_role_policy" "dynamodb_task" {
  name = "dynamodb-task"
  role = aws_iam_role.task_role.name
  policy = data.aws_iam_policy_document.ecs_task_app.json
}


resource "aws_iam_role" "blue_green_role" {
    name = "blue_green_infra_role"

    assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action = "sts:AssumeRole"
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "blue_green_policy" {
  role = aws_iam_role.blue_green_role.name
  policy_arn = var.infrastructure_policy_arn
}