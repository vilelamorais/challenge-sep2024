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

variable "security_group_ids" {
  default = [
    "sg-02c5a680a49d3da6a"
  ]
  description = "VPC Security groups"
  type        = list(string)
}

variable "vpc_2nd_cidr" {
  default     = "10.200.0.0/16"
  description = "VPC secundary CIDR"
  type        = string
}
