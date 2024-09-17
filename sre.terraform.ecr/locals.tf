locals {
  ecr_name = "ecr-${var.deploy_name}"

  tags = {
    GithubModule  = "https://github.com/terraform-aws-modules/terraform-aws-ecr"
    ResourceType  = "ECR"
    ResourceGroup = "EKS centralizado"
    Client        = "Jabuti Technology"
    Terraform     = true
  }
}