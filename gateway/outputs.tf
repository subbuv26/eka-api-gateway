output "gateway_v2_id" {
  value = aws_apigatewayv2_api.jina_apps_gw.id
}

output "gateway_custom_api_url" {
  value = aws_apigatewayv2_domain_name.apps_custom_domain.domain_name_configuration.0.target_domain_name
}
