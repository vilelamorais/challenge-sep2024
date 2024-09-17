provider "aws" {
  region  = var.region
  profile = "c-eks"
}

terraform {
  required_version = "~> 1.9"

  backend "s3" {
    bucket  = "j-eks-centralizado"
    key     = "tfstate/vpc.tfstate"
    region  = "us-east-1"
    profile = "c-eks"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.65.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }
}