output "github_oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = aws_iam_openid_connect_provider.github_oidc.arn
}

output "github_app_role_arn" {
  description = "ARN of the IAM role assumed by GitHub Actions for the app repository"
  value       = aws_iam_role.github_app.arn
}

output "github_infra_role_arn" {
  description = "ARN of the IAM role assumed by GitHub Actions for the infra repository"
  value       = aws_iam_role.github_infra.arn
}

output "github_app_allowed_sub" {
  description = "Allowed GitHub OIDC subject for the app repository"
  value       = local.app_sub
}

output "github_infra_allowed_sub" {
  description = "Allowed GitHub OIDC subject for the infra repository"
  value       = local.infra_sub
}
