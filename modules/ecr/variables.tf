variable "repository_name" {
  description = "ECR repository name"
  type        = string
}

variable "image_tag_mutability" {
  description = "Image tag mutability for the repository"
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["IMMUTABLE", "MUTABLE"], var.image_tag_mutability)
    error_message = "The image_tag_mutability value must be either IMMUTABLE or MUTABLE."
  }
}

variable "scan_on_push" {
  description = "Enable basic scan on push"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Encryption type for ECR repository"
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "The encryption_type value must be either AES256 or KMS."
  }
}

variable "create_lifecycle_policy" {
  description = "Whether to create a lifecycle policy"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to resources"
  type        = map(string)
  default     = {}
}

variable "force_delete" {
  description = "Force delete of ECR repository"
  type        = bool
  default     = true // Enabled for the current lab - In production, set to false
}
