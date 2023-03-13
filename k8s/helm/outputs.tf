output "app_name" {
  value = random_pet.name.id
}

output "app_domain" {
  value = "${random_pet.name.id}.${var.ingress_internal_domain}"
}

output "lb_url" {
  value = data.kubernetes_ingress_v1.app_ingress.status.0.load_balancer.0.ingress.0.hostname
}
