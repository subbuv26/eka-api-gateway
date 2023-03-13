module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = var.unique_name
  cidr = var.cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
    "kubernetes.io/role/elb"     = 1
    "kubernetes.io/cluster/${var.unique_name}" = "owned"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/${var.unique_name}"      = "owned"
  }
}

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.25.0"

  cluster_name    = var.unique_name
  cluster_version = var.cluster_version
  enable_irsa     = true

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnets
#  public_subnet_ids = module.vpc.public_subnets

  managed_node_groups = {
    role = {
      capacity_type   = var.node_capacity_type
      node_group_name = "general"
      instance_types  = var.node_instance_type
      desired_size    = "1"
      max_size        = "3"
      min_size        = "1"
    }
  }
}

#data "aws_route53_zone" "jina_domain" {
#  name         = "${var.cluster_domain}."
#  private_zone = false
#}

module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons"

  eks_cluster_id = module.eks_blueprints.eks_cluster_id

  # EKS Addons
  enable_amazon_eks_vpc_cni = true

  #K8s Add-ons
#  enable_external_dns = true
#  external_dns_private_zone = false
#  eks_cluster_domain = "${var.cluster_domain}."

#  external_dns_route53_zone_arns = [
#      data.aws_route53_zone.jina_domain.arn
#  ]

  enable_aws_load_balancer_controller = true

  depends_on = [
    null_resource.setup_kube_config
  ]
}

provider "kubernetes" {
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks_blueprints.eks_cluster_id]
  }
}

resource "null_resource" "setup_kube_config" {

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.region} --name ${var.unique_name}"
  }
  depends_on = [module.eks_blueprints]
}
