variable "vpc_cidr" {
  type = string

}

variable "vpc_name" {
  type = string
}

variable "region" {
  type = string
}

variable "az" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "app_name" {
  type = string
  default = "url-shortener"
}

variable "domain" {
  type = string
}

variable "execution_role_name" {
  type    = string
  default = "ecsTaskExecutionRole"
}

variable "execution_policy_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

variable "task_role_name" {
  type = string
  default = "ecsTaskRole"
}

variable "image_tag" {
  type = string
  default = "latest"
}