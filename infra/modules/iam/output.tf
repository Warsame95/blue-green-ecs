output "execution_role_arn" {
  value = aws_iam_role.execution_role.arn
}

output "task_role_arn" {
  value = aws_iam_role.task_role.arn
}

output "blue_green_infra_role" {
  value = aws_iam_role.blue_green_role.arn
}