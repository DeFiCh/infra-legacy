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
  name               = "cluster-autoscaler"
  policy_description = "Policy to allow cluster autoscaler access to autoscaling group"
  role_description   = "IAM role to allow cluster autoscaler access to autoscaling group"

  policy_documents = [
    jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeAutoScalingInstances",
            "autoscaling:DescribeLaunchConfigurations",
            "autoscaling:DescribeScalingActivities",
            "autoscaling:DescribeTags",
            "ec2:DescribeImages",
            "ec2:DescribeInstanceTypes",
            "ec2:DescribeLaunchTemplateVersions",
            "ec2:GetInstanceTypesFromInstanceRequirements",
            "eks:DescribeNodegroup"
          ],
          "Resource" : ["*"]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "autoscaling:SetDesiredCapacity",
            "autoscaling:TerminateInstanceInAutoScalingGroup"
          ],
          "Resource" : ["*"]
        }
      ]
    })
  ]

  principals = {
    Federated = [dependency.eks.outputs.oidc_provider_arn]
  }

  assume_role_actions = ["sts:AssumeRoleWithWebIdentity"]
  assume_role_conditions = [
    {
      test     = "StringLike"
      variable = "${dependency.eks.outputs.oidc_provider}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }
  ]

  context = dependency.labels.outputs.context
}
