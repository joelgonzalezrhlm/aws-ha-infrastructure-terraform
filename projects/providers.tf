terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
    }
  }

  backend "s3" {
    bucket       = "project-cool-terraform-state-bucket"
    key          = "prod/terraform.state"
    region       = "eu-south-2"
    use_lockfile = true
  }
}

provider "aws" {
  region = "eu-south-2"
}