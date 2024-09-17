locals {
  azs              = slice(data.aws_availability_zones.available.names, 0, var.num_azs)
  
  kms_name = "kms-${var.deploy_name}"

  tags = {
    GithubModule  = "https://github.com/terraform-aws-modules/terraform-aws-kms"
    ResourceType  = "Encryption service"
    ResourceGroup = "EKS centralizado"
    Client        = "Jabuti Technology"
    Terraform     = true
  }
}