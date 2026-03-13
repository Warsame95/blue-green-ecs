resource "aws_lb" "main-alb" {
  name               = "${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = var.public_subnet_ids
  

}

resource "aws_lb_target_group" "url-service-tg" {
  name     = "${var.app_name}-service-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  ip_address_type = "ipv4"
  target_type = "ip"
  

  health_check {
    enabled = true
    healthy_threshold = 5
    interval = 30
    matcher = "200"
    path = "/healthz"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 2
  }

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

  stickiness {
    type = "lb_cookie"
    enabled = true
    cookie_duration = 86400
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