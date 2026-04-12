variable "app_name" {
  type = string
}

variable "region" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "container_image" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "alternate_target_group_arn" {
  type = string
}

variable "production_listener_rule_arn" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "repo_uri" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "blue_green_infra_role" {
  type = string
}