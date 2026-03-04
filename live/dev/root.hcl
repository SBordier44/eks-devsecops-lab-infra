locals {
  env     = "dev"
  region  = "eu-west-3"
  project = "eks-devsecops-lab"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "eks-devsecops-lab-tf-state"
    key            = "${local.project}/${local.env}/terraform.tfstate"
    region         = local.region
    dynamodb_table = "eks-devsecops-lab-tf-lock"
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

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  terraform {
    backend "s3" {}
  }
  EOF
}
