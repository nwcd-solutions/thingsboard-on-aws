module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 5.0"

  identifier = local.db_name

  engine               = "postgres"
  engine_version       = "12.8"
  family               = "postgres12"
  major_engine_version = "12"
  instance_class       = "db.m6i.large"

  storage_type      = "io1"
  allocated_storage = 100
  iops              = 1000

  db_name                = local.db_name
  username               = local.db_username
  create_random_password = false
  password               = sensitive(aws_secretsmanager_secret_version.postgres.secret_string)
  port                   = 5432

  multi_az               = true
  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.security_group.security_group_id]

  deletion_protection     = false

  tags = local.tags
}

#---------------------------------------------------------------
# Postgres DB Master password
#---------------------------------------------------------------
resource "random_password" "postgres" {
  length  = 16
  special = false
}
#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "postgres" {
  name                    = "postgres1"
  recovery_window_in_days = 0 # Set to zero for this example to force delete during Terraform destroy
}

resource "aws_secretsmanager_secret_version" "postgres" {
  secret_id     = aws_secretsmanager_secret.postgres.id
  secret_string = random_password.postgres.result
}

