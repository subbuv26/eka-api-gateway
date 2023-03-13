output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cluster_name" {
  value = module.eks_blueprints.eks_cluster_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}
