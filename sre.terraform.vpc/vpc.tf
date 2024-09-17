module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  create_vpc = true

  name                  = local.vpc_name
  cidr                  = var.vpc_1st_cidr
  secondary_cidr_blocks = [var.vpc_2nd_cidr]
  azs                   = local.azs
  public_subnets        = [for k, v in local.azs : cidrsubnet(var.vpc_1st_cidr, 8, k)]
  private_subnets       = [for k, v in local.azs : cidrsubnet(var.vpc_1st_cidr, 8, k + 100)]
  # database_subnets      = [for k, v in local.azs : cidrsubnet(var.vpc_1st_cidr, 8, k + 200)]
  intra_subnets         = [for k, v in local.azs : cidrsubnet(var.vpc_2nd_cidr, 8, k)]

  enable_ipv6 = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  manage_default_network_acl    = false
  public_dedicated_network_acl  = true
  private_dedicated_network_acl = true
  intra_dedicated_network_acl   = true

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = var.enable_vpc_flowlogs
  create_flow_log_cloudwatch_log_group = var.enable_vpc_flowlogs
  create_flow_log_cloudwatch_iam_role  = var.enable_vpc_flowlogs
  flow_log_max_aggregation_interval    = var.vpc_flowlogs_aggregation

  tags = local.tags

  public_subnet_tags = merge(local.tags, {
    "tier" = "public"
  })

  private_subnet_tags = merge(local.tags, {
    "tier" = "private"
  })

  intra_subnet_tags = merge(local.tags, {
    "tier" = "intra"
  })
}