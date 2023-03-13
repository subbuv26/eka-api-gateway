variable "values_file" {}

variable "replicaCount" {
  default = 1
}

variable "ingress_internal_domain" {}

variable "ingress_listen_ports" {}
variable "ingress_target_type" {}
variable "ingress_backend_protocol_version" {}
variable "ingress_subnets" {}
variable "ingress_scheme" {}
