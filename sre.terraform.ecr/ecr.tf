module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.2.1"

  create_repository = var.custom_create_repository

  repository_name = local.ecr_name
  repository_type = var.custom_repository_type

  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]

  create_lifecycle_policy                = var.custom_create_lifecycle_policy
  manage_registry_scanning_configuration = var.custom_manage_registry_scanning_configuration

  tags = local.tags
}