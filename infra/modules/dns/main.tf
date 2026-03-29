data "aws_route53_zone" "zone" {
  name         = "urlshortener.click"
  private_zone = false
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = var.dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }

  
}