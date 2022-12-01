data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
#
# KMS Key for cloudwatch
#
module "log_key" {
  source      = "../kms"
  alias       = "cloudwatch/msk/${var.cluster_name}"
  description = "KMS key for data encryption of Cloudwatch logs"
  roles       = [data.aws_caller_identity.current.arn]
  services    = [
     "logs.${data.aws_region.current.name}.amazonaws.com",  
     "delivery.logs.amazonaws.com"
   ]
}

#
# Log group
#
resource "aws_cloudwatch_log_group" "log" {
  name              = "/msk/${var.cluster_name}"
  retention_in_days = 7
  kms_key_id        = module.log_key.arn
}

#
# KMS Key for MSK
#
module "kms" {
  source      = "../kms"
  alias       = "msk/${var.cluster_name}"
  description = "KMS key for data encryption of MSK EBS volumes"
  roles       = [data.aws_caller_identity.current.arn]
}

#
# MSK Cluster
#
resource "aws_msk_cluster" "cluster" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = length(var.subnet_ids)

  broker_node_group_info {
    instance_type  = var.instance_type
    client_subnets = var.subnet_ids
    storage_info {
      ebs_storage_info {
        volume_size = var.storage_size
      }
    }
    security_groups = var.security_group_ids
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = module.kms.arn
  }

   client_authentication {
      unauthenticated = false
      sasl {
         iam = true
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

  enhanced_monitoring = var.enhanced_monitoring_level

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.log.name
      }
    }
  }
}

