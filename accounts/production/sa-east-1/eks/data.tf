data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.production.id]
  }

  tags = {
    Tier = "Private"
  }
}

data "aws_acm_certificate" "issued" {
  domain   = "argocd.descoshop.com.br"
  statuses = ["ISSUED"]
}

data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.production.id]
  }

  tags = {
    Tier = "public"
  }
}

data "aws_vpc" "production" {

  tags = {
    "Terraform" = "True"
    "Environment" = "production"
  }
  
}