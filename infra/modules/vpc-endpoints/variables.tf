variable "vpc_id" {
  type = string
}

variable "region" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "private_rtb_id" {
  type = string
}

variable "ecs_sg_id" {
  type = string
}