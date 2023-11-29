module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "${var.name}-vpc"
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  database_subnets = var.database_subnets

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
    "Tier" = "public"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "Tier" = "private"
  }

  database_subnet_tags = {
    "database" = 1
  }

  enable_nat_gateway = true
  single_nat_gateway = true
  create_database_subnet_group = true
  database_subnet_group_name = "${var.name}-db"

  tags = var.tags
}