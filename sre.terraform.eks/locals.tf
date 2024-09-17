locals {
  #=============================================================================
  # General locals
  resources_prefix = var.deploy_name
  account_id       = data.aws_caller_identity.current.account_id
  azs              = slice(data.aws_availability_zones.available.names, 0, var.num_azs)

  #=============================================================================
  # EKS Locals
  cluster_name    = "cluster-${var.deploy_name}"
  cluster_version = "1.30"

  # cluster autoscaler
  serviceaccount_name      = "cluster-autoscaler"
  serviceaccount_namespace = "kube-system"

  #=============================================================================
  # Other resources
  vpc_name = "vpc-${var.deploy_name}"

  sso_role_arn = [
    for role in data.aws_iam_roles.sso_roles.arns : role if can(regex("^arn:aws:iam::[0-9]+:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_[0-9a-f]{16}$", role))
  ][0]

  #=============================================================================
  # Tags
  tags = {
    GithubModule  = "https://github.com/terraform-aws-modules/terraform-aws-eks"
    ResourceType  = "EKS Cluster"
    ResourceGroup = "EKS centralizado"
    Client        = "Jabuti Technology"
    Terraform     = true
  }
}