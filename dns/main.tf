data "aws_route53_zone" "jina_domain" {
  name         = "${var.cluster_domain}."
  private_zone = false
}


resource "aws_route53_record" "internal_record" {
  name    = var.internal_domain
  type    = "CNAME"
  zone_id = data.aws_route53_zone.jina_domain.zone_id
  ttl = 300
  records = [var.lb_url]
}

resource "aws_apigatewayv2_integration" "jina_app" {
  api_id = var.api_gw_v2_id

  integration_uri    = "https://${var.internal_domain}:443/{proxy}"
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  connection_type    = "INTERNET"
}

resource "aws_apigatewayv2_route" "app_route" {
  api_id = var.api_gw_v2_id

  route_key = "ANY ${var.app_path}/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.jina_app.id}"
}
