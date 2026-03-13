data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count) // create a list of azs limited to the number of AZs requested

  // /16 -> split into /20 blocks
  public_subnets  = [for i in range(var.az_count) : cidrsubnet(var.vpc_cidr, 4, i)]                // create a list of public subnets in the VPC CIDR block with /20 subnets per AZ 10.0.0.0/20, 10.0.16.0/20, etc.
  private_subnets = [for i in range(var.az_count) : cidrsubnet(var.vpc_cidr, 4, i + var.az_count)] // create a list of private subnets in the VPC CIDR block with /20 subnets per AZ 10.0.32.0/20, 10.0.48.0/20, etc.
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.6"

  name                 = var.name
  cidr                 = var.vpc_cidr
  azs                  = local.azs
  public_subnets       = local.public_subnets
  private_subnets      = local.private_subnets
  enable_dns_hostnames = true
  enable_dns_support   = true
  create_igw           = true
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = true
  public_subnet_tags = merge(var.tags, {
    "kubernetes.io/role/elb"                        = "1"
    "kubernetes.io/cluster/${var.cluster_tag_name}" = "shared"
  })
  private_subnet_tags = merge(var.tags, {
    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/${var.cluster_tag_name}" = "shared"
  })
  map_public_ip_on_launch = true
  tags = var.tags
}

resource "aws_security_group" "vpce" {
  count       = var.enable_vpc_endpoints ? 1 : 0
  name        = "${var.name}-vpce"
  description = "Security group for VPC interface endpoints"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

module "vpc_endpoints" {
  count   = var.enable_vpc_endpoints ? 1 : 0
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 6.6"

  vpc_id             = module.vpc.vpc_id
  tags               = var.tags
  security_group_ids = [aws_security_group.vpce[0].id]
  subnet_ids         = module.vpc.private_subnets

  endpoints = {
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
    }
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
    }
    sts = {
      service             = "sts"
      private_dns_enabled = true
    }
    logs = {
      service             = "logs"
      private_dns_enabled = true
    }
  }
}

module "s3_gateway_endpoint" {
  count   = var.enable_s3_gateway_endpoint ? 1 : 0
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 6.6"

  vpc_id = module.vpc.vpc_id
  tags   = var.tags

  endpoints = {
    s3 = {
      service      = "s3"
      service_type = "Gateway"
      route_table_ids = concat(
        module.vpc.private_route_table_ids,
        module.vpc.public_route_table_ids
      )
    }
  }
}
