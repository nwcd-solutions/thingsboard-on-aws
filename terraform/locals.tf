locals {

  name            = "thingsboard"
  region          = data.aws_region.current.name
  cluster_version = "1.22"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  node_group_name = "tb-node"

  db_name = "thingsboard"
  db_username = "postgres"

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/aws-ia/terraform-aws-eks-blueprints"
  }
}
