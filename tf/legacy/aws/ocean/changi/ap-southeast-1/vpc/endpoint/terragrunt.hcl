include "envcommon" {
  path = "${dirname(find_in_parent_folders("provider.hcl"))}/_commons/vpc/endpoint.hcl"
}

include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

inputs = {
  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = flatten([dependency.vpc.outputs.private_route_table_ids, dependency.vpc.outputs.public_route_table_ids])
      tags            = { Name = "${dependency.labels.outputs.id}-s3-vpc-endpoint" }
    }
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
      tags                = { Name = "${dependency.labels.outputs.id}-ecr-dkr-vpc-endpoint" }
    }
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = dependency.vpc.outputs.private_subnets
      tags                = { Name = "${dependency.labels.outputs.id}-ecr-api-vpc-endpoint" }
    }
  }
}
