variable "unique_name" {
  type = string
  default =  "my-eks-cluster"
}

variable "region" {}

variable "cluster_version" {
  type = string
  default = "1.25"
}

variable "cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "private_subnets" {
  type = list(string)
  default = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "public_subnets" {
  type = list(string)
  default = ["10.0.64.0/19", "10.0.96.0/19"]
}

variable "node_capacity_type" {
  description = "Capacity Type of eks nodes"
  default = "ON_DEMAND"
}

variable "node_instance_type" {
  type = list(string)
  default = [
    "t3.small",
    "t2.small"
  ]
}

variable "cluster_domain" {}
