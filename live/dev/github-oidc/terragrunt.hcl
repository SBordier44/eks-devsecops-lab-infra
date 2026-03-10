include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  env     = local.root.locals.env
  region  = local.root.locals.region
  project = local.root.locals.project
}

dependency "ecr" {
  config_path = "../ecr"

  # Instead of configuring an actual dependency, we mock the outputs of the dependency by
  # overriding the outputs with values that are acceptable for testing.
  mock_outputs = {
    ecr_repository_arn = "arn:aws:ecr:us-east-1:111111111111:repository/mock"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

terraform {
  source = "${get_repo_root()}/modules/github_oidc"
}

inputs = {
  project               = local.project
  environment           = local.env
  github_owner          = "SBordier44"
  app_repository_name   = "eks-devsecops-lab-app"
  infra_repository_name = "eks-devsecops-lab-infra"
  app_allowed_branch    = "main"
  app_environment_name  = "production"
  infra_allowed_branch  = "main"
  ecr_repository_arn    = dependency.ecr.outputs.repository_arn
  max_session_duration  = 3600

  tags = {
    Project   = local.project
    Env       = local.env
    ManagedBy = "terraform"
  }
}
