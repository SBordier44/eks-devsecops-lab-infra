module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.15.1"

  name                                     = var.name
  kubernetes_version                       = var.kubernetes_version
  vpc_id                                   = var.vpc_id
  subnet_ids                               = var.private_subnet_ids
  endpoint_public_access                   = var.endpoint_public_access
  endpoint_private_access                  = var.endpoint_private_access
  endpoint_public_access_cidrs             = var.endpoint_public_access_cidrs
  enable_cluster_creator_admin_permissions = true
  enable_irsa                              = true

  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    eks-pod-identity-agent = {
      before_compute = true
    }
  }

  eks_managed_node_groups = {
    workers = {
      name                     = "${var.name}-workers"
      instance_types           = var.node_instance_types
      min_size                 = var.node_min_size
      max_size                 = var.node_max_size
      desired_size             = var.node_desired_size
      ami_type                 = "AL2023_x86_64_STANDARD"
      iam_role_use_name_prefix = false
      iam_role_name            = "${var.name}-workers"
      tags = merge(var.tags, {
        Name = "${var.name}-workers"
      })
    }
  }

}
