locals {
  instance_types = [
    "m5.xlarge",
    "m5a.xlarge",
    "m5d.xlarge",
    "m6a.xlarge",
    "m6i.xlarge",
    "m6id.xlarge"
  ]

  admin_role_arns = yamldecode(sops_decrypt_file("${dirname(find_in_parent_folders("env.hcl"))}/secrets/roles.yaml")).admins
}


include "provider" {
  path = find_in_parent_folders("provider.hcl")
}

include "envcommon" {
  path           = "${dirname(find_in_parent_folders("provider.hcl"))}/_commons/eks/common.hcl"
  merge_strategy = "deep"
}

inputs = {
  cluster_version = "1.28"

  eks_managed_node_group_defaults = {
    ami_type      = "AL2_x86_64"
    capacity_type = "SPOT"
    desired_size  = 0
    max_size      = 10
    min_size      = 0
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 32
          volume_type           = "gp3"
          delete_on_termination = true
        }
      }
    }
    instance_types = local.instance_types
  }

  eks_managed_node_groups = {
    # ec2-instance-selector --memory 16 --vcpus 4 --gpus 0 --cpu-architecture x86_64 --current-generation -r ap-southeast-1 -z ap-southeast-1a -u spot -o table-wide
    "eks-mxlarge-1a" = {
      name         = "eks-mxlarge"
      subnet_ids   = [dependency.vpc.outputs.private_subnets[0]]
      desired_size = 1
      min_size     = 1
    }
    "eks-mxlarge-1b" = {
      name       = "eks-mxlarge"
      subnet_ids = [dependency.vpc.outputs.private_subnets[1]]
    }
    "eks-mxlarge-1c" = {
      name       = "eks-mxlarge"
      subnet_ids = [dependency.vpc.outputs.private_subnets[2]]
    }
  }

  kms_key_administrators = local.admin_role_arns
}
