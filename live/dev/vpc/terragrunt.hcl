include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  env              = local.root.locals.env
  region           = local.root.locals.region
  project          = local.root.locals.project
  name             = "${local.project}-${local.env}-vpc"
  cluster_tag_name = "${local.project}-${local.env}"
}

terraform {
  source = "${get_repo_root()}/modules/vpc"
}

inputs = {
  name                 = local.name
  region               = local.region
  vpc_cidr             = "10.0.0.0/16"
  az_count             = 2
  enable_nat_gateway   = true
  enable_vpc_endpoints = false
  enable_s3_gateway_endpoint = true
  cluster_tag_name     = local.cluster_tag_name
  tags = {
    Project   = local.project
    Env       = local.env
    ManagedBy = "terraform"
  }
}
