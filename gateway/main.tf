data "aws_acm_certificate" "jina_dev_cert" {
  domain = var.eks_cluster_domain
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "jina_domain" {
  name         = "${var.eks_cluster_domain}."
  private_zone = false
}

resource "aws_apigatewayv2_api" "jina_apps_gw" {
  name          = var.eks_cluster_name
  protocol_type = "HTTP"
  disable_execute_api_endpoint = false
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id = aws_apigatewayv2_api.jina_apps_gw.id

  name        = var.deploy_stage
  auto_deploy = true
}

resource "aws_apigatewayv2_domain_name" "apps_custom_domain" {
  domain_name = var.gateway_domain_name
  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.jina_dev_cert.arn
    endpoint_type   = var.endpoint_type
    security_policy = var.security_policy
  }
}

resource "aws_apigatewayv2_api_mapping" "jina_apps_mapping" {
  api_id      = aws_apigatewayv2_api.jina_apps_gw.id
  domain_name = aws_apigatewayv2_domain_name.apps_custom_domain.id
  stage       = aws_apigatewayv2_stage.stage.id
}

resource "aws_security_group" "vpc_link_sg" {
  name   = "${var.eks_cluster_name}-vpc-link-sg"
  vpc_id = var.aws_vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_apigatewayv2_vpc_link" "eks" {
  name               = "${var.eks_cluster_name}-vpc-link"
  security_group_ids = [aws_security_group.vpc_link_sg.id]
  subnet_ids = var.public_subnets
}

resource "aws_route53_record" "public_api_record" {
  name    = var.gateway_domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.jina_domain.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_apigatewayv2_domain_name.apps_custom_domain.domain_name_configuration.0.target_domain_name
#    zone_id                = data.aws_route53_zone.execute_domain.zone_id
    zone_id                = aws_apigatewayv2_domain_name.apps_custom_domain.domain_name_configuration.0.hosted_zone_id
  }
}
