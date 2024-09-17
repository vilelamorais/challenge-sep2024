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

variable "vpc_1st_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR"
  type        = string
}

variable "vpc_2nd_cidr" {
  default     = "10.200.0.0/16"
  description = "VPC secundary CIDR"
  type        = string
}

variable "enable_vpc_flowlogs" {
  default     = false
  description = "VPC flowlogs definition"
  type        = bool
}

variable "vpc_flowlogs_aggregation" {
  default     = "60"
  description = "Maximum flow log aggregation interval"
  type        = number
}