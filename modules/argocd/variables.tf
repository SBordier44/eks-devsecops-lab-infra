variable "cluster_name" {
  type = string
}

variable "namespace" {
  type    = string
  default = "argocd"
}

variable "chart_version" {
  type    = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
