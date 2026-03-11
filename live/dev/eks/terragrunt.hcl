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

  // Instead of configuring an actual dependency, we mock the outputs of the dependency by
  // overriding the outputs with values that are acceptable for testing.
  mock_outputs = {
    vpc_id = "vpc-00000000000000000"
    private_subnet_ids = ["subnet-00000000000000000", "subnet-11111111111111111"]
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  // End
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
  endpoint_private_access = true

  endpoint_public_access = true
  # Override this from CLI or env when needed:
  # export TF_VAR_endpoint_public_access_cidrs="[\"YOUR_PUBLIC_IP/32\"]"
  endpoint_public_access_cidrs = ["0.0.0.0/0"]

  node_instance_types = ["t3.medium"]
  node_min_size     = 2
  node_max_size     = 2
  node_desired_size = 2
  tags = {
    Project   = local.project
    Env       = local.env
    ManagedBy = "terraform"
  }
}
