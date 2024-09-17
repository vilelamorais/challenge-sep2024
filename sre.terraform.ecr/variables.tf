#===============================================================================
# Setup variables
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

variable "iam_pipeline" {
  default     = "github-pipelene"
  description = "Pipeline user"
  type        = string
}

#===============================================================================
# ECR variables

variable "custom_attach_repository_policy" {
  description = "Determines whether a repository policy will be attached to the repository"
  type        = bool
  default     = true
}

variable "custom_create" {
  type        = bool
  description = "Determines whether resources will be created (affects all resources)"
  default     = true
}

variable "custom_create_lifecycle_policy" {
  type        = bool
  description = "Determines whether a lifecycle policy will be created"
  # default     = true  # default
  default = false
}

variable "custom_create_registry_policy" {
  type        = bool
  description = "Determines whether a registry policy will be created"
  default     = false
}

variable "custom_create_registry_replication_configuration" {
  type        = bool
  description = "Determines whether a registry replication configuration will be created"
  default     = false
}

variable "custom_create_repository" {
  type        = bool
  description = "Determines whether a repository will be created"
  default     = true
}

variable "custom_create_repository_policy" {
  type        = bool
  description = "Determines whether a repository policy will be created"
  default     = true
}

variable "custom_manage_registry_scanning_configuration" {
  type        = bool
  description = "Determines whether the registry scanning configuration will be managed"
  default     = false
}

variable "custom_public_repository_catalog_data" {
  type        = any
  description = "Catalog data configuration for the repository"
  default     = {}
}

variable "custom_registry_policy" {
  type        = string
  description = "The policy document. This is a JSON formatted string"
  default     = null
}

variable "custom_registry_pull_through_cache_rules" {
  type        = map(map(string))
  description = "List of pull through cache rules to create"
  default     = {}
}

variable "custom_registry_replication_rules" {
  type        = any
  description = "The replication rules for a replication configuration. A maximum of 10 are allowed"
  default     = []
}

variable "custom_registry_scan_rules" {
  type        = any
  description = "One or multiple blocks specifying scanning rules to determine which repository filters are used and at what frequency scanning will occur"
  default     = []
}

variable "custom_registry_scan_type" {
  type        = string
  description = "the scanning type to set for the registry. Can be either `ENHANCED` or `BASIC`"
  default     = "ENHANCED"
}

variable "custom_repository_encryption_type" {
  type        = string
  description = "The encryption type for the repository. Must be one of: `KMS` or `AES256`. Defaults to `AES256`"
  default     = null
}

variable "custom_repository_force_delete" {
  type        = bool
  description = "If `true`, will delete the repository even if it contains images. Defaults to `false`"
  default     = null
}

variable "custom_repository_image_scan_on_push" {
  type        = bool
  description = "Indicates whether images are scanned after being pushed to the repository (`true`) or not scanned (`false`)"
  default     = true
}

variable "custom_repository_image_tag_mutability" {
  type        = string
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`. Defaults to `IMMUTABLE`"
  default     = "IMMUTABLE"
}

variable "custom_repository_kms_key" {
  type        = string
  description = "The ARN of the KMS key to use when encryption_type is `KMS`. If not specified, uses the default AWS managed key for ECR"
  default     = null
}

variable "custom_repository_lambda_read_access_arns" {
  type        = list(string)
  description = "The ARNs of the Lambda service roles that have read access to the repository"
  default     = []
}

variable "custom_repository_lifecycle_policy" {
  type        = string
  description = "The policy document. This is a JSON formatted string. See more details about [Policy Parameters](http://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html#lifecycle_policy_parameters) in the official AWS docs"
  default     = ""
}

variable "custom_repository_name" {
  type        = string
  description = "The name of the repository"
  default     = ""
}

variable "custom_repository_policy" {
  type        = string
  description = "The JSON policy to apply to the repository. If not specified, uses the default policy"
  default     = null
}

variable "custom_repository_policy_statements" {
  type        = any
  description = "A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage"
  default     = {}
}

variable "custom_repository_read_access_arns" {
  type        = list(string)
  description = "The ARNs of the IAM users/roles that have read access to the repository"
  default     = []
}

variable "custom_repository_read_write_access_arns" {
  type        = list(string)
  description = "The ARNs of the IAM users/roles that have read/write access to the repository"
  default     = []
}

variable "custom_repository_type" {
  type        = string
  description = "The type of repository to create. Either `public` or `private`"
  default     = "private"
}

variable "custom_tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
  default     = {}
} 