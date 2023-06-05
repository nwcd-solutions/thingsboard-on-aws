resource "kubectl_manifest" "tb-namespace" {
  yaml_body = file("kubectl_manifest/tb-namespace.yaml")
  depends_on = [module.eks_blueprints.eks_cluster_id]
}

resource "kubectl_manifest" "tb-node-db-configmap" {
  yaml_body = templatefile("kubectl_manifest/tb-node-db-configmap.yaml",{YOUR_RDS_ENDPOINT_URL=module.db.db_instance_endpoint,YOUR_RDS_PASSWORD=aws_secretsmanager_secret_version.postgres.secret_string})
  depends_on = [kubectl_manifest.tb-namespace,module.db]
}

resource "kubectl_manifest" "tb-redis-configmap" {
  yaml_body =  templatefile("kubectl_manifest/tb-redis-configmap.yaml",{YOUR_REDIS_ENDPOINT_URL_WITHOUT_PORT=resource.aws_elasticache_replication_group.thingsboard.primary_endpoint_address})
  depends_on = [kubectl_manifest.tb-namespace,resource.aws_elasticache_replication_group.thingsboard]
}

resource "kubectl_manifest" "tb-kafka-configmap" {
  yaml_body = templatefile("kubectl_manifest/tb-kafka-configmap.yaml", {MSK_BOOTSTRAP_BROKER= resource.aws_msk_cluster.thingsboard.bootstrap_brokers})
  depends_on = [kubectl_manifest.tb-namespace, resource.aws_msk_cluster.thingsboard]
}



