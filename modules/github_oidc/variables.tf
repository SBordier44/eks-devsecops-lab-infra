variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "github_owner" {
  description = "GitHub organization or user name"
  type        = string
}

variable "app_repository_name" {
  description = "GitHub repository name for the application repository"
  type        = string
}

variable "infra_repository_name" {
  description = "GitHub repository name for the infrastructure repository"
  type        = string
}

variable "app_allowed_branch" {
  description = "Allowed Git branch for the app repository"
  type        = string
  default     = "main"
}

variable "infra_allowed_branch" {
  description = "Allowed Git branch for the infra repository"
  type        = string
  default     = "main"
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository used by the application pipeline"
  type        = string
}

variable "tags" {
  description = "Common AWS tags"
  type        = map(string)
  default     = {}
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds for GitHub assumed roles"
  type        = number
  default     = 3600
}
