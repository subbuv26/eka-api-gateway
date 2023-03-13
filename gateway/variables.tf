variable "eks_cluster_name" {}
variable "aws_vpc_id" {}
variable "region" {}

variable "public_subnets" {
  type = list(string)
}

variable "eks_cluster_domain" {}

variable "gateway_domain_name" {
  default = "apps.dev.jina.ai"
}

variable "deploy_stage" {
  default = "poc"
}

variable "endpoint_type" {
  default = "REGIONAL"
}

variable "security_policy" {
  default = "TLS_1_2"
}

