resource "aws_elasticache_replication_group" "thingsboard" {
  replication_group_id    = local.name
  description             = "Redis cache for Thingsboard Cluster"
  engine                  = "redis"
  node_type               = "cache.m5.large"
  num_cache_clusters      = 2
  automatic_failover_enabled  = true
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.2"
  port                 = 6379
  multi_az_enabled     = true
  
  security_group_ids   = [module.security_group.security_group_id]
  #az_mode              = "cross-az"
  subnet_group_name    = aws_elasticache_subnet_group.RedisSubnetGroup.name
}

resource "aws_elasticache_subnet_group" "RedisSubnetGroup" {
  name       = "RedisSubnetGroup"
  subnet_ids = module.vpc.private_subnets
}
