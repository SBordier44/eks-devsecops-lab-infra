variable "name" {
  type = string
}
variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "kubernetes_version" {
  type    = string
  default = "1.35"
}

variable "endpoint_public_access" {
  type    = bool
  default = true
}

variable "endpoint_private_access" {
  type    = bool
  default = true
}

# IPv4 CIDR list allowed to reach the public Kubernetes API endpoint.
# For this lab, the cluster is created as an IPv4 EKS cluster, so use IPv4 CIDRs only.
#
# Example:
# export TF_VAR_endpoint_public_access_cidrs="[\"82.67.127.199/32\"]"
#
# Get your public IPv4 with:
# curl -4 -s https://ifconfig.me
variable "endpoint_public_access_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "node_desired_size" {
  type    = number
  default = 1
}
variable "node_min_size" {
  type    = number
  default = 1
}
variable "node_max_size" {
  type    = number
  default = 2
}

variable "tags" {
  type    = map(string)
  default = {}
}
