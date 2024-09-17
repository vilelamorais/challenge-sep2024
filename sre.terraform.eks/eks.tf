#===============================================================================
# Cluster EKS - eks-centralizado
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  vpc_id                   = data.aws_vpc.vpc.id
  subnet_ids               = data.aws_subnets.vpc-private-subnets.ids
  control_plane_subnet_ids = data.aws_subnets.vpc-intra-subnets.ids

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  # cluster_addons = {
  #   coredns = {
  #     most_recent = true
  #   }
  #   kube-proxy = {
  #     most_recent = true
  #   }
  #   vpc-cni = {
  #     most_recent = true
  #   }
  #   aws-ebs-csi-driver = {
  #     most_recent = true
  #   }
  #   aws-efs-csi-driver = {
  #     most_recent = true
  #   }
  # }

  access_entries = {
    sso_access = {
      principal_arn = local.sso_role_arn
      policy_associations = {
        sso_accessadmin_pipeline = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        },
        sso_accessadmincluster_pipeline = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  eks_managed_node_group_defaults = {
    ami_type       = var.aws_ami_type
    disk_size      = 100
    instance_types = ["t3a.large", "t3.large"]
  }

  tags = local.tags
}

#===============================================================================
# EKS Node Group
module "ng-general" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.24.0"

  create = var.create_ng_general
  name   = "ng-general"

  cluster_name         = module.eks.cluster_name
  cluster_version      = module.eks.cluster_version
  cluster_service_cidr = module.eks.cluster_service_cidr

  subnet_ids                        = data.aws_subnets.vpc-private-subnets.ids
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id

  vpc_security_group_ids = [
    module.eks.cluster_security_group_id
  ]

  desired_size = 1
  min_size     = 1
  max_size     = 6

  iam_role_attach_cni_policy = true

  instance_types = ["t3a.large"]
  capacity_type  = "SPOT"
  # capacity_type  = "ON_DEMAND"

  use_custom_launch_template = false
  disk_size                  = 100

  ami_type = var.aws_ami_type

  tags = merge(local.tags, {
    Tier = "General Node Group"
  })
}

module "ng-prd" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.24.0"

  create = var.create_ng_prd
  name   = "ng-prd"

  cluster_name         = module.eks.cluster_name
  cluster_version      = module.eks.cluster_version
  cluster_service_cidr = module.eks.cluster_service_cidr

  subnet_ids                        = data.aws_subnets.vpc-private-subnets.ids
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id

  vpc_security_group_ids = [
    module.eks.cluster_security_group_id
  ]

  desired_size = 1
  min_size     = 1
  max_size     = 6

  iam_role_attach_cni_policy = true

  instance_types = ["t3a.large"]
  capacity_type  = "SPOT"
  # capacity_type  = "ON_DEMAND"

  use_custom_launch_template = false
  disk_size                  = 100

  taints = [
    {
      key    = "dedicated"
      value  = "prd"
      effect = "NO_EXECUTE"
    }
  ]

  ami_type = var.aws_ami_type

  tags = merge(local.tags, {
    Tier = "Production Node Group"
  })
}

module "ng-dev" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.24.0"

  create = var.create_ng_dev
  name   = "ng-dev"

  cluster_name         = module.eks.cluster_name
  cluster_version      = module.eks.cluster_version
  cluster_service_cidr = module.eks.cluster_service_cidr

  subnet_ids                        = data.aws_subnets.vpc-private-subnets.ids
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id

  vpc_security_group_ids = [
    module.eks.cluster_security_group_id
  ]

  desired_size = 2
  min_size     = 1
  max_size     = 6

  iam_role_attach_cni_policy = true

  instance_types = ["t3a.large"]
  capacity_type  = "SPOT"
  # capacity_type  = "ON_DEMAND"

  use_custom_launch_template = false
  disk_size                  = 100
  enable_monitoring          = true

  taints = [
    {
      key    = "dedicated"
      value  = "dev"
      effect = "NO_EXECUTE"
    }
  ]

  ami_type = var.aws_ami_type

  tags = merge(local.tags, {
    Tier = "Development Node Group"
  })
}

module "ng-infra" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.24.0"

  create = var.create_ng_infra
  name   = "ng-infra"

  cluster_name         = module.eks.cluster_name
  cluster_version      = module.eks.cluster_version
  cluster_service_cidr = module.eks.cluster_service_cidr

  subnet_ids                        = data.aws_subnets.vpc-private-subnets.ids
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id

  vpc_security_group_ids = [
    module.eks.cluster_security_group_id
  ]

  desired_size = 1
  min_size     = 1
  max_size     = 6

  iam_role_attach_cni_policy = true

  instance_types = ["t3a.large"]
  capacity_type  = "SPOT"
  # capacity_type  = "ON_DEMAND"

  use_custom_launch_template = false
  disk_size                  = 100

  taints = [
    {
      key    = "dedicated"
      value  = "infra"
      effect = "NO_EXECUTE"
    }
  ]

  ami_type = var.aws_ami_type

  tags = merge(local.tags, {
    Tier = "Infrastructure Node Group"
  })
}

#===============================================================================
# EKS Addons

resource "aws_iam_role" "vpc_cni_role" {
  assume_role_policy = data.aws_iam_policy_document.vpc_cni_assume_role_policy.json
  name               = "${local.resources_prefix}-vpc-cni-role"

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "vpc_cni_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpc_cni_role.name
}

# vpc-cni
resource "aws_eks_addon" "vpc-cni" {
  cluster_name                = module.eks.cluster_name
  depends_on                  = [aws_iam_role.vpc_cni_role]
  addon_name                  = "vpc-cni"
  addon_version               = "v1.18.3-eksbuild.3"
  resolve_conflicts_on_update = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"
  service_account_role_arn    = aws_iam_role.vpc_cni_role.arn

  configuration_values = jsonencode({
    eniConfig = {
      create = true
      region = substr(var.vpc_azs[0], 0, length(var.vpc_azs[0]) - 1) # how to get vpc_azs with data
      # region = data.aws_region.current.name
      subnets = {
        for index, az in var.vpc_azs :
        az => { id = var.intra_subnets_id[index] }
        # az => { id = data.aws_subnets.vpc-intra-subnets.ids[index] } # How to get index from data output
      }
    }
    env = {
      AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG = "true"
      ENABLE_PREFIX_DELEGATION           = "true"
      ENI_CONFIG_LABEL_DEF               = "topology.kubernetes.io/zone"
    }
  })

  tags = local.tags
}

# kube-proxy
resource "aws_eks_addon" "kube-proxy" {
  cluster_name                = module.eks.cluster_name
  addon_name                  = "kube-proxy"
  addon_version               = "v1.30.3-eksbuild.5"
  resolve_conflicts_on_update = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"

  tags = local.tags
}

# # coredns
# resource "aws_eks_addon" "core_dns" {
#   cluster_name                = module.eks.cluster_name
#   addon_name                  = "coredns"
#   addon_version               = "v1.11.3-eksbuild.1"
#   resolve_conflicts_on_update = "OVERWRITE"
#   resolve_conflicts_on_create = "OVERWRITE"

#   tags = local.tags
# }

# EFS CSI Driver
resource "aws_iam_role" "efs_csi_driver_role" {
  name = "efs_csi_driver_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Federated" : "arn:aws:iam::${local.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${element(split("/", module.eks.oidc_provider), length(split("/", module.eks.oidc_provider)) - 1)}"
      },
      "Action" : "sts:AssumeRoleWithWebIdentity",
      "Condition" : {
        "StringEquals" : {
          "oidc.eks.${var.region}.amazonaws.com/id/${element(split("/", module.eks.oidc_provider), length(split("/", module.eks.oidc_provider)) - 1)}:aud" : "sts.amazonaws.com",
          "oidc.eks.${var.region}.amazonaws.com/id/${element(split("/", module.eks.oidc_provider), length(split("/", module.eks.oidc_provider)) - 1)}:sub" : "system:serviceaccount:kube-system:efs-csi-controller-sa"
        }
      }
    }]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "efs-csi-attach" {
  role       = aws_iam_role.efs_csi_driver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
}

resource "aws_eks_addon" "aws-efs-csi-driver" {
  cluster_name = module.eks.cluster_name
  depends_on = [
    module.ng-general
    , aws_iam_role.efs_csi_driver_role
  ]
  addon_name                  = "aws-efs-csi-driver"
  addon_version               = "v2.0.7-eksbuild.1"
  resolve_conflicts_on_update = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"
  service_account_role_arn    = aws_iam_role.ebs_csi_driver_role.arn

  tags = local.tags
}

# EBS CSI Driver
resource "aws_iam_role" "ebs_csi_driver_role" {
  name = "ebs_csi_driver_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Federated" : "arn:aws:iam::${local.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${element(split("/", module.eks.oidc_provider), length(split("/", module.eks.oidc_provider)) - 1)}"
      },
      "Action" : "sts:AssumeRoleWithWebIdentity",
      "Condition" : {
        "StringEquals" : {
          "oidc.eks.${var.region}.amazonaws.com/id/${element(split("/", module.eks.oidc_provider), length(split("/", module.eks.oidc_provider)) - 1)}:aud" : "sts.amazonaws.com",
          "oidc.eks.${var.region}.amazonaws.com/id/${element(split("/", module.eks.oidc_provider), length(split("/", module.eks.oidc_provider)) - 1)}:sub" : "system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "ebs-csi-attach" {
  role       = aws_iam_role.ebs_csi_driver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_addon" "aws-ebs-csi-driver" {
  cluster_name = module.eks.cluster_name
  depends_on = [
    module.ng-general
    , aws_iam_role.ebs_csi_driver_role
  ]
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.34.0-eksbuild.1"
  resolve_conflicts_on_update = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"
  service_account_role_arn    = aws_iam_role.ebs_csi_driver_role.arn

  tags = local.tags
}

#===============================================================================
# Security groups
resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "${local.resources_prefix}-internal-http"
  vpc_id      = data.aws_vpc.vpc.id
  description = "Allow HTTP access"

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }

  tags = merge(local.tags, {
    "name" = "${local.resources_prefix}-internal-https"
  })
}

resource "aws_security_group" "worker_group_mgmt_two" {
  name_prefix = "${local.resources_prefix}-internal-http"
  vpc_id      = data.aws_vpc.vpc.id
  description = "Allow HTTPS access"

  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"

    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }

  tags = merge(local.tags, {
    "name" = "${local.resources_prefix}-internal-https"
  })
}

#===============================================================================
# Security groups - extra
resource "aws_security_group" "eks_allow_all" {
  name_prefix = "${local.cluster_name}-allow-all"
  vpc_id      = data.aws_vpc.vpc.id
  description = "Allow all access"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    "Name" = "${local.resources_prefix}-all-trafic"
  })
}

#===============================================================================
# k8s basic config

# Define gp3 as default storage type
resource "kubernetes_storage_class" "ebs_csi_gp3_storage_class" {
  metadata {
    name = "ebs-csi-gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = true
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"
  parameters = {
    type = "gp3"
  }
}

resource "kubernetes_storage_class" "ebs_csi_encrypted_gp3_storage_class" {
  metadata {
    name = "ebs-csi-encrypted-gp3"
  }

  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"
  parameters = {
    encrypted = true
    type      = "gp3"
  }
}

resource "kubernetes_namespace" "namespaces" {
  for_each = toset(var.namespace_list)

  metadata {
    name = each.value
  }
}

#===============================================================================
# Cluster Autoscaler

# resource "helm_release" "cluster_autoscaler" {
#   name             = "cluster-autoscaler"
#   namespace        = "kube-system"
#   repository       = "https://kubernetes.github.io/autoscaler"
#   chart            = "cluster-autoscaler"
#   version          = "9.10.8"
#   create_namespace = false

#   set {
#     name  = "awsRegion"
#     value = var.region
#   }

#   set {
#     name  = "rbac.serviceAccount.name"
#     value = "cluster-autoscaler-aws"
#   }

#   set {
#     name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = module.iam_assumable_role_cluster_autoscaler.iam_role_arn
#     type  = "string"
#   }

#   set {
#     name  = "autoDiscovery.clusterName"
#     value = local.cluster_name
#   }

#   set {
#     name  = "autoDiscovery.enabled"
#     value = "true"
#   }

#   set {
#     name  = "rbac.create"
#     value = "true"
#   }

#   depends_on = [
#     module.eks.cluster_id
#   ]
# }

# module "iam_assumable_role_cluster_autoscaler" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#   version = "~> 4.0"

#   create_role      = true
#   role_name_prefix = "cluster-autoscaler"
#   role_description = "IRSA role for cluster autoscaler"

#   provider_url                   = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
#   role_policy_arns               = [aws_iam_policy.cluster_autoscaler.arn]
#   oidc_fully_qualified_subjects  = ["system:serviceaccount:kube-system:cluster-autoscaler-aws"]
#   oidc_fully_qualified_audiences = ["sts.amazonaws.com"]

#   tags = local.tags
# }

# resource "aws_iam_policy" "cluster_autoscaler" {
#   name   = "KarpenterControllerPolicy-refresh"
#   policy = data.aws_iam_policy_document.cluster_autoscaler.json

#   tags = local.tags
# }

#===============================================================================
# Karpenter

module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"

  version = "20.24.0"

  cluster_name = module.eks.cluster_name

  enable_v1_permissions = true

  enable_pod_identity             = true
  create_pod_identity_association = true

  # Used to attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = local.tags
}