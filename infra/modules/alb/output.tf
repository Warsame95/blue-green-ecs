output "alb_sg_id" {
  value = aws_security_group.alb-sg.id
}

output "dns_name" {
  value = aws_lb.main-alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.main-alb.zone_id
}

output "target_group_arn" {
  value = aws_lb_target_group.blue.arn
}

output "alternate_target_group_arn" {
  value = aws_lb_target_group.green
}

output "production_listener_rule_arn" {
  value = aws_lb_listener_rule.production_listener_rule.arn
}

output "alb_arn" {
  value = aws_lb.main-alb.arn
}