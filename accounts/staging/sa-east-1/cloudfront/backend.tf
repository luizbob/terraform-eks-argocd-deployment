provider "aws" {
  region = var.region
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
  }
  backend "s3" {}
}