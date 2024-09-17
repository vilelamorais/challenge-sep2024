variable "region" {
  default     = "us-east-1"
  description = "AWS region"
  type        = string
}

variable "num_azs" {
  default     = "3"
  description = "Numbers of AZs"
  type        = number
}

variable "deploy_name" {
  default     = "eks-centralizado"
  description = "Deploy name"
  type        = string
}

variable "aws_root_account_identifier" {
  default = []
  type    = set(string)
}

variable "aws_ami_type" {
  default = "BOTTLEROCKET_x86_64"
  type    = string
}

#===============================================================================
# Nodegroup config variables

variable "create_ng_general" {
  description = "Create (true) or not (false) general node group"
  type        = bool
  default     = false
}

variable "create_ng_infra" {
  description = "Create (true) or not (false) infrastructure node group"
  type        = bool
  default     = false
}

variable "create_ng_prd" {
  description = "Create (true) or not (false) production node group"
  type        = bool
  default     = false
}

variable "create_ng_dev" {
  description = "Create (true) or not (false) develop node group"
  type        = bool
  default     = false
}

#===============================================================================
# Kubernetes config variables
variable "namespace_list" {
  description = "K8s namespaces to create"
  type        = list(string)
  default = [
    "production"
    , "development"
    , "demo"
    , "infrastructure"
  ]
}

#===============================================================================
# VPC variables not accquired with data
variable "intra_subnets_id" {
  default = [
    "subnet-0ffdea63f515d8525",
    "subnet-050682890570015f8",
    "subnet-0bf3d925d526852ca"
  ]
  description = "Intra subnet IDs"
  type        = list(string)
}

variable "vpc_azs" {
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
  ]
  type = list(string)
}

#===============================================================================
# cluster autoscaler variables
variable "fullname_override" {
  type        = string
  default     = "aws-cluster-autoscaler"
  description = "Helm fullnameOverride"
}

variable "settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values."
}