output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = module.eks_blueprints.configure_kubectl
}

output "sg" {
  description = "sg of eks cluster "
  value = module.eks_blueprints.cluster_primary_security_group_id
}

output "msk_endpoint" {
  description = "kafaka endpoint"
  value = resource.aws_msk_cluster.thingsboard.bootstrap_brokers
}

output "redis_endpoint" {
  description = "redis endpoint"
  value= resource.aws_elasticache_replication_group.thingsboard.configuration_endpoint_address
}
