terraform {
  backend "s3" {
    bucket       = "extracircular-terraform-state-prod"
    key          = "prod/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
