module "platform" {
  source = "../../modules/platform"

  environment            = "dev"
  domain_name            = "projectlearning.click"
  eks_node_instance_type = "t3.medium"
  eks_desired_nodes      = 1
  rds_instance_class     = "db.t3.micro"
  rds_multi_az           = false # Single-AZ lab mode from your diagram
}
