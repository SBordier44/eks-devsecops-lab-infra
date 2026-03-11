include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  env     = local.root.locals.env
  region  = local.root.locals.region
  project = local.root.locals.project
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    cluster_name = "eksdsl-dev"
  }

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

terraform {
  source = "${get_repo_root()}/modules/argocd"
}

generate "k8s_providers" {
  path      = "k8s-providers.tf"
  if_exists = "overwrite"
  contents  = <<EOF
    data "aws_eks_cluster" "this" {
      name = var.cluster_name
    }

    data "aws_eks_cluster_auth" "this" {
      name = var.cluster_name
    }

    provider "kubernetes" {
      host                   = data.aws_eks_cluster.this.endpoint
      cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
      token                  = data.aws_eks_cluster_auth.this.token
    }

    provider "helm" {
      kubernetes = {
        host                   = data.aws_eks_cluster.this.endpoint
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
        token                  = data.aws_eks_cluster_auth.this.token
      }
    }
    EOF
}

inputs = {
  cluster_name  = dependency.eks.outputs.cluster_name
  namespace     = "argocd"
  chart_version = "9.4.10"

  tags = {
    Project   = local.project
    Env       = local.env
    ManagedBy = "terraform"
  }
}
