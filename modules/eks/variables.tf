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

// Specify a private IP address with CIDR prefix length for accessing the Kubernetes API
// Using environment variables to override TF_VAR_endpoint_public_access_cidrs
// ex: export TF_VAR_endpoint_public_access_cidrs="[\"$MY_IP4\",\"$MY_IP6\"]"
// Get your IP4 address with: curl -4 -s https://ifconfig.me
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
