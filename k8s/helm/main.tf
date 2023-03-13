resource "random_pet" "name" {}

data "aws_acm_certificate" "amazon_issued" {
  domain      = "*.${var.ingress_internal_domain}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "helm_release" "jina_app_release" {
  name       = "jina-app-release"
  repository = "k8s"
  chart      = "jina_app"
  version    = "1.0"

  values = [
    file(var.values_file)
  ]

  set {
    name  = "fullname"
    value = random_pet.name.id
  }

  set {
    name  = "name"
    value = random_pet.name.id
  }

  set {
    name  = "namespace"
    value = "${random_pet.name.id}-ns"
  }

  set {
    name  = "replicaCount"
    value = var.replicaCount
  }

  set {
    name  = "ingress.internal_domain_name"
    value = "${random_pet.name.id}.${var.ingress_internal_domain}"
  }

#  set {
#    name  = "alb.ingress.kubernetes.io/listen_ports"
#    value = join("",var.ingress_listen_ports)
#  }
#
#  set {
#    name  = "alb.ingress.kubernetes.io/target_type"
#    value = var.ingress_target_type
#  }
#
#  set {
#    name  = "alb.ingress.kubernetes.io/backend_protocol_version"
#    value = var.ingress_backend_protocol_version
#  }
#
#  set {
#    name  = "alb.ingress.kubernetes.io/subnets"
#    type = "string"
#    value = var.ingress_subnets
#  }
#
#  set {
#    name  = "alb.ingress.kubernetes.io/scheme"
#    value = var.ingress_scheme
#  }
#
#  set {
#    name  = "alb.ingress.kubernetes.io/certificate_arn"
#    value = data.aws_acm_certificate.amazon_issued.arn
#  }

}

resource "kubernetes_annotations" "ingress" {
  annotations = {
    "alb.ingress.kubernetes.io/listen-ports": var.ingress_listen_ports
    "alb.ingress.kubernetes.io/target-type": var.ingress_target_type
    "alb.ingress.kubernetes.io/backend-protocol-version": var.ingress_backend_protocol_version
    "alb.ingress.kubernetes.io/subnets": join(",",var.ingress_subnets)
    "alb.ingress.kubernetes.io/scheme": var.ingress_scheme
    "alb.ingress.kubernetes.io/certificate-arn": data.aws_acm_certificate.amazon_issued.arn
  }
  api_version = "networking.k8s.io/v1"
  kind        = "Ingress"
  force = true
  metadata {
    name = random_pet.name.id
    namespace = "${random_pet.name.id}-ns"
  }

#  depends_on = [helm_release.jina_app_release]
}

#resource "kubernetes_ingress_v1" "app_ingress" {
#  metadata {
#    name = random_pet.name.id
#    namespace = "${random_pet.name.id}-ns"
#  }
#  spec {
#    ingress_class_name = "alb"
#    rule {
#      host = "${random_pet.name.id}.${var.ingress_internal_domain}"
#      path {
#        backend {
#          service {
#            name = random_pet.name.id
#            port {
#              number = 50050
#            }
#          }
#          path = "/"
#        }
#      }
#    }
#  }
#  wait_for_load_balancer = true
#}

data "kubernetes_ingress_v1" "app_ingress" {
  metadata {
    name = random_pet.name.id
    namespace = "${random_pet.name.id}-ns"
  }
}
