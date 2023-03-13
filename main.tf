resource "random_pet" "uid" {}

module "eks" {
  source = "./eks"

  unique_name = random_pet.uid.id
  region = var.region
  cluster_version = var.eks_cluster_version
  cluster_domain = var.eks_cluster_domain
  node_instance_type = [var.eks_node_instance_type]
}

module "k8s_app" {
  source = "./k8s/helm"

  values_file = "k8s/jina_app/values.yaml"

  ingress_backend_protocol_version = var.ingress_backend_protocol_version
  ingress_internal_domain          = var.ingress_internal_domain
  ingress_listen_ports             = var.ingress_listen_ports
  ingress_scheme                   = var.ingress_scheme
  ingress_subnets                  = module.eks.public_subnets
  ingress_target_type              = var.ingress_target_type

#  depends_on = [module.eks]
}

module "api_gateway" {
  source = "./gateway"
  aws_vpc_id = module.eks.vpc_id
  eks_cluster_name = module.eks.cluster_name
  public_subnets = module.eks.public_subnets
  eks_cluster_domain = var.eks_cluster_domain
  region = var.region

#  depends_on = [module.eks]
}

module "dns" {
  source = "./dns"

  cluster_domain  = var.eks_cluster_domain
  internal_domain = module.k8s_app.app_domain
  lb_url          = module.k8s_app.lb_url
  api_gw_v2_id    = module.api_gateway.gateway_v2_id
  app_name = module.k8s_app.app_name
  app_path        = "/${module.k8s_app.app_name}/api"

#  depends_on = [
#    module.eks,
#    module.k8s_app,
#    module.api_gateway
#  ]
}
