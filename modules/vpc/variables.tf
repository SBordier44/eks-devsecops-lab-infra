variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "az_count" {
  type    = number
  default = 2
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "cluster_tag_name" {
  type = string
}

variable "enable_nat_gateway" {
  type    = bool
  default = false // disabled to limit credit consumption for this lab
}

variable "enable_vpc_endpoints" {
  type    = bool
  default = true
}
