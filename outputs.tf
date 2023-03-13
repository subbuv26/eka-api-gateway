output "cluster_name" {
  value = module.eks.cluster_name
}

#output "jina_domain_arn" {
#  value = module.eks.jina_domain_arn
#}

#output "app_name" {
#  value = module.k8s_app.app_name
#}
#
#output "app_domain" {
#  value = module.k8s_app.app_domain
#}
#
#output "lb_url" {
#  value = module.k8s_app.lb_url
#}
#
#output "api_gw_custom_url" {
#  value = module.api_gateway.gateway_custom_api_url
#}

output "app_fqdn_path" {
  value = "https://${var.gateway_domain_name}/${module.k8s_app.app_name}/api/"
}
