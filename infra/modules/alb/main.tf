resource "aws_lb" "main-alb" {
  name               = "${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = var.public_subnet_ids
  

}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main-alb.arn
  certificate_arn = var.acm_certificate_arn
  protocol = "HTTPS"
  port = 443
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener_rule" "production_listener_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority = 100

  action {
    type = "forward"
    forward {
      target_group {
        arn =  aws_lb_target_group.blue.arn
        weight = 100
      }
      target_group {
        arn = aws_lb_target_group.green.arn
        weight = 0
      }
    }
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_lb_target_group" "blue" {
  name     = "${var.app_name}-blue-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  ip_address_type = "ipv4"
  target_type = "ip"
  

  health_check {
    enabled = true
    healthy_threshold = 2
    interval = 5
    matcher = "200"
    path = "/healthz"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 4
    unhealthy_threshold = 2
  }

  deregistration_delay = 5

  target_group_health {
    dns_failover {
      minimum_healthy_targets_count = "1"
      minimum_healthy_targets_percentage = "off"
    }

    unhealthy_state_routing {
      minimum_healthy_targets_count = 1
      minimum_healthy_targets_percentage = "off"
    }

  }


}

resource "aws_lb_target_group" "green" {
  name     = "${var.app_name}-green-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  ip_address_type = "ipv4"
  target_type = "ip"
  

  health_check {
    enabled = true
    healthy_threshold = 2
    interval = 5
    matcher = "200"
    path = "/healthz"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 4
    unhealthy_threshold = 2
  }

  deregistration_delay = 5

  target_group_health {
    dns_failover {
      minimum_healthy_targets_count = "1"
      minimum_healthy_targets_percentage = "off"
    }

    unhealthy_state_routing {
      minimum_healthy_targets_count = 1
      minimum_healthy_targets_percentage = "off"
    }

  }


}

resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Allows https traffic into ecs"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }

}