variable "region" {
  default = "ap-south-1"
}

# EKS Cluster defaults
variable "eks_cluster_version" {
  # gets overwritten by terraform.tfvars
  default = "1.24"
}

variable "eks_cluster_domain" {
  default = "dev.jina.ai"
}
variable "gateway_domain_name" {
  default = "apps.dev.jina.ai"
}
variable "ingress_internal_domain" {
  default = "internal.dev.jina.ai"
}

variable "eks_node_instance_type" {
  default = "t3.small"
}

# App defaults
variable "replicaCount" {
  default = 1
}

variable "ingress_listen_ports" {
  type = string
  default = "[{\"HTTPS\":443}]"
}
variable "ingress_target_type" {
  default = "ip"
}
variable "ingress_backend_protocol_version" {
  default = "HTTP1"
}
variable "ingress_scheme" {
  default = "internet-facing"
}
