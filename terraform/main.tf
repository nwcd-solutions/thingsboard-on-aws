module "eks_blueprints" {

  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.27.0"
  cluster_name    = local.name

  # EKS Cluster VPC and Subnet mandatory config
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  # EKS CONTROL PLANE VARIABLES
  cluster_version = local.cluster_version

  # List of Additional roles admin in the cluster
  # Comment this section if you ARE NOT at an AWS Event, as the TeamRole won't exist on your site, or replace with any valid role you want
  map_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TeamRole"
      username = "ops-role" # The user name within Kubernetes to map to the IAM role
      groups   = ["system:masters"] # A list of groups within Kubernetes to which the role is mapped; Checkout K8s Role and Rolebindings
    }
  ]

  # EKS MANAGED NODE GROUPS
  managed_node_groups = {
    mg_5 = {
      node_group_name = local.node_group_name
      instance_types  = ["m5.xlarge"]
      disk_size       = 80
      subnet_ids      = module.vpc.private_subnets
      max_size               = 3
      min_size               = 3
      desired_size           = 3
      additional_tags = {
         Name = "tb-node"
      }
      k8s_labels = {
         role= "tb-node"
      }
    }
  }

  tags = local.tags
}

module "kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.27.0/modules/kubernetes-addons"

  eks_cluster_id     = module.eks_blueprints.eks_cluster_id

  enable_aws_load_balancer_controller  = true

}  

