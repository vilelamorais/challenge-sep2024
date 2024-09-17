module "kms" {
  source = "terraform-aws-modules/terraform-aws-kms"

  description = "EC2 AutoScaling key usage"
  key_usage   = "ENCRYPT_DECRYPT"

  # Policy
  key_administrators                 = [
    "arn:aws:iam::${data.aws_caller_identity.current.id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_*",
    "arn:aws:iam::${data.aws_caller_identity.current.id}:user/github-pipeline"
  ]
  key_service_roles_for_autoscaling  = ["arn:aws:iam::${data.aws_caller_identity.current.id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]

  # Aliases
  aliases = ["${var.deploy_name}/ebs"]

  tags = local.tags
}