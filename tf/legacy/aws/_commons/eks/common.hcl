dependency "labels" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/labels"
}

dependency "vpc" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/vpc"
}

terraform {
  source = "tfr:///terraform-aws-modules/eks/aws//.?version=20.10.0"
}

inputs = {
  # Cluster settings
  cluster_name                             = dependency.labels.outputs.id
  cluster_version                          = "1.28"
  cluster_enabled_log_types                = ["audit"]
  enable_irsa                              = true
  cluster_endpoint_private_access          = true
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  # Encryption
  cluster_encryption_config = {
    resources = ["secrets"]
  }

  # Addons
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  # Vpc settings
  vpc_id                   = dependency.vpc.outputs.vpc_id
  subnet_ids               = dependency.vpc.outputs.private_subnets
  control_plane_subnet_ids = dependency.vpc.outputs.intra_subnets

  # EKS Managed Node Group defaults
  eks_managed_node_group_defaults = {
    capacity_type = "SPOT"
    iam_role_additional_policies = {
      AmazonEKSClusterPolicy         = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
      AmazonEKSServicePolicy         = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
      AmazonEKSVPCResourceController = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
      CloudWatchAgentServerPolicy    = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    }
    tags = merge(
      { for k, v in dependency.labels.outputs.tags : k => v if k != "Name" },
      {
        "k8s.io/cluster-autoscaler/${dependency.labels.outputs.id}" = "owned"
        "k8s.io/cluster-autoscaler/enabled"                         = "true"
      }
    )
  }

  node_security_group_additional_rules = {
    node_https = {
      description = "This allows pods on different nodes to talk to eachother on port 443, required for Rancher"
      type        = "ingress"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      self        = true
    }
    node_http = {
      description = "This allows pods on different nodes to talk to eachother on port 80, required for Rancher"
      type        = "ingress"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      self        = true
    }
  }

  tags = { for k, v in dependency.labels.outputs.tags : k => v if k != "Name" }
}
