variable "environment" {
  type = string
}

variable "project_name" {
  type    = string
  default = "extracircular"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "domain_name" {
  type = string
}

variable "eks_node_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "eks_desired_nodes" {
  type    = number
  default = 2
}

variable "rds_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "rds_multi_az" {
  type    = bool
  default = false
}

variable "ecr_repositories" {
  type = list(string)
  default = [
    "frontend", "api-gateway",
    "activity-service-1", "activity-service-2", "activity-service-3",
    "activity-service-4", "activity-service-5", "activity-service-6",
    "activity-service-7", "activity-service-8", "activity-service-9"
  ]
}
