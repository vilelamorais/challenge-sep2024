################################################################################
# RDS Module
################################################################################

module "db" {
  source = "terraform-aws-modules/terraform-aws-rds"
  version = "6.9.0"

  identifier                     = local.rds_name
  instance_use_identifier_prefix = true

  create_db_option_group    = false
  create_db_parameter_group = false

  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class       = "db.t4g.large"

  allocated_storage = 20

  db_name  = local.db_name
  username = "db_admin_user"
  port     = 5432

  db_subnet_group_name   = var.intra_subnets_id
  vpc_security_group_ids = var.security_group_ids

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 0

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "db-sg-${var.deploy_name}"
  description = "Complete PostgreSQL example security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = var.vpc_2nd_cidr
    },
  ]

  tags = local.tags
}