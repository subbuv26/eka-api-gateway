output "app_route_url" {
  value = join("", ["https://", var.cluster_domain, var.app_path])
}
