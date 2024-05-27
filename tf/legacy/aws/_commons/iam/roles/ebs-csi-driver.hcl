dependency "labels" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/labels"
}

terraform {
  source = "tfr:///cloudposse/iam-role/aws//.?version=0.19.0"
}

dependency "eks" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/eks"
}

inputs = {
  name               = "ebs-csi-driver"
  policy_description = "Policy to allow EBS Provisioning"
  role_description   = "IAM role to allow EBS Provisioning"

  policy_document_count = 0
  managed_policy_arns   = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]

  principals = {
    Federated = [dependency.eks.outputs.oidc_provider_arn]
  }

  assume_role_actions = ["sts:AssumeRoleWithWebIdentity"]
  assume_role_conditions = [
    {
      test     = "StringLike"
      variable = "${dependency.eks.outputs.oidc_provider}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
  ]

  context = dependency.labels.outputs.context
}
