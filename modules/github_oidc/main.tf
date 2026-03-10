locals {
  name_prefix     = "${var.project}-${var.environment}"
  app_role_name   = "${local.name_prefix}-github-app"
  infra_role_name = "${local.name_prefix}-github-infra"
  github_oidc_url = "https://token.actions.githubusercontent.com"
  app_sub         = "repo:${var.github_owner}/${var.app_repository_name}:environment:${var.app_environment_name}"
  infra_sub       = "repo:${var.github_owner}/${var.infra_repository_name}:ref:refs/heads/${var.infra_allowed_branch}"
}

resource "aws_iam_openid_connect_provider" "github_oidc" {
  url             = local.github_oidc_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]
  tags            = var.tags
}

data "aws_iam_policy_document" "github_app_assume_role" {
  statement {
    sid     = "GitHubOidcAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_oidc.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [local.app_sub]
    }
  }
}

data "aws_iam_policy_document" "github_infra_assume_role" {
  statement {
    sid     = "GitHubOidcAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_oidc.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [local.infra_sub]
    }
  }
}

resource "aws_iam_role" "github_app" {
  name                 = local.app_role_name
  assume_role_policy   = data.aws_iam_policy_document.github_app_assume_role.json
  max_session_duration = var.max_session_duration
  tags                 = var.tags
}

resource "aws_iam_role" "github_infra" {
  name                 = local.infra_role_name
  assume_role_policy   = data.aws_iam_policy_document.github_infra_assume_role.json
  max_session_duration = var.max_session_duration
  tags                 = var.tags
}

data "aws_iam_policy_document" "github_app_ecr" {
  statement {
    sid    = "AllowGetEcrAuthorizationToken"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowPushPullOnSpecificEcrRepository"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [var.ecr_repository_arn]
  }
}

resource "aws_iam_policy" "github_app_ecr" {
  name        = "${local.name_prefix}-github-app-ecr"
  description = "Policy for GitHub App to access ECR"
  policy      = data.aws_iam_policy_document.github_app_ecr.json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "github_app_ecr" {
  role       = aws_iam_role.github_app.name
  policy_arn = aws_iam_policy.github_app_ecr.arn
}
