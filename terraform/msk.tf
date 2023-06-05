resource "aws_msk_cluster" "thingsboard" {
  cluster_name           = "thingsboard"
  kafka_version          = "2.6.2"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type = "kafka.m5.large"
    client_subnets = module.vpc.private_subnets
    storage_info {
      ebs_storage_info {
        volume_size = 100
      }
    }
    security_groups = [module.security_group.security_group_id]
  }

  encryption_info {
    encryption_in_transit {
        client_broker  =  "TLS_PLAINTEXT"
    }
  }
  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  tags = {
    foo = "bar"
  }
}
