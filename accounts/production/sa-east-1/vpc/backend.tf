provider "aws" {
  region = var.region
}
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
  backend "s3" {}
}