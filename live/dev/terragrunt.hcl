locals {
  env     = "dev"
  region  = "eu-west-3"
  project = "eks-devsecops-lab"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = ""
    key            = "${local.project}/${local.env}/terraform.tfstate"
    region         = local.region
    dynamodb_table = ""
    encrypt        = true
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  provider "aws" {
    region = "${local.region}"
  }
  EOF
}
