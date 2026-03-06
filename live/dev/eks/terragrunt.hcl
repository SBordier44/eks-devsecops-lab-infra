include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  env     = local.root.locals.env
  region  = local.root.locals.region
  project = local.root.locals.project
  name    = "eksdsl-${local.env}"
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "${get_repo_root()}/modules/eks"
}

inputs = {
  name                    = local.name
  region                  = local.region
  vpc_id                  = dependency.vpc.outputs.vpc_id
  private_subnet_ids      = dependency.vpc.outputs.private_subnet_ids
  kubernetes_version      = "1.35"
  endpoint_public_access  = true
  endpoint_private_access = true
  endpoint_public_access_cidrs = ["0.0.0.0/0"]
  node_instance_types = ["t3.small"]
  node_min_size           = 1
  node_max_size           = 2
  node_desired_size       = 1
  tags = {
    Project   = local.project
    Env       = local.env
    ManagedBy = "terraform"
  }
}
