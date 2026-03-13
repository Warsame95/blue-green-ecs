output "alb_sg_id" {
  value = aws_security_group.alb-sg.id
}

output "dns_name" {
  value = aws_lb.test.dns_name
}

output "zone_id" {
  value = aws_lb.test.zone_id
}

output "target_group_arn" {
  value = aws_lb_target_group.url-service-tg.arn
}