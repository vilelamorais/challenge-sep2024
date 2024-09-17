locals {
  vpc_name = "vpc-${var.deploy_name}"
  azs      = slice(data.aws_availability_zones.available.names, 0, var.num_azs)

  tags = {
    GithubModule  = "https://github.com/terraform-aws-modules/terraform-aws-vpc"
    ResourceType  = "Network VPC"
    ResourceGroup = "EKS centralizado"
    Client        = "Jabuti Technology"
    Terraform     = true
  }
}