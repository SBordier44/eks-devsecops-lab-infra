include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

terraform {
  source = "${get_repo_root()}/modules/ecr"
}

inputs = {
  repository_name         = "eks-devsecops-lab-dev-app"
  image_tag_mutability    = "IMMUTABLE"
  scan_on_push            = true
  encryption_type         = "AES256"
  create_lifecycle_policy = true

  tags = {
    Project   = "eks-devsecops-lab"
    Env       = "dev"
    Owner     = "sylvain"
    ManagedBy = "terraform"
  }
}
