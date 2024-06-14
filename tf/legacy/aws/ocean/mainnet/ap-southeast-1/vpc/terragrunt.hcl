include "envcommon" {
  path = "${dirname(find_in_parent_folders("provider.hcl"))}/_commons/vpc/common.hcl"
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

locals {
  vpc_cidr = "10.31.0.0/16"
  region   = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.region
  azs      = ["${local.region}a", "${local.region}b", "${local.region}c"]
}

inputs = {
  cidr = local.vpc_cidr

  azs                 = local.azs
  private_subnets     = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 6, k)]
  public_subnets      = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 6, k + 3)]
  database_subnets    = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 6, k + 6)]
  elasticache_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 6, k + 9)]
  redshift_subnets    = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 6, k + 12)]
  intra_subnets       = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 6, k + 15)]

  enable_nat_gateway = true
  single_nat_gateway = true
}
