provider "aws" {
  region  = var.region
  profile = "c-eks"
}

terraform {
  required_version = "~> 1.5"

  backend "s3" {
    bucket  = "j-eks-centralizado"
    key     = "tfstate/rds.tfstate"
    region  = "us-east-1"
    profile = "c-eks"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.65.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32.0"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.15.0"
    }
  }
}