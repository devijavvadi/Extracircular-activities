module "platform" {
  source = "../../modules/platform"

  environment            = "prod"
  domain_name            = "yourdomain.com"
  eks_node_instance_type = "t3.large"
  eks_desired_nodes      = 2
  rds_instance_class     = "db.t3.medium"
  rds_multi_az           = true # Multi-AZ standby failover enabled
}
