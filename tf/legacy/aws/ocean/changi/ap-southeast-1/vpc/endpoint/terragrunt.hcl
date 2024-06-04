include "envcommon" {
  path = "${dirname(find_in_parent_folders("provider.hcl"))}/_common/vpc/endpoint.hcl"
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
  }
}
