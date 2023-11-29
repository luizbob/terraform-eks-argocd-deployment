data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.staging.id]
  }

  tags = {
    Tier = "Private"
  }
}

data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.staging.id]
  }

  tags = {
    Tier = "public"
  }
}

data "aws_vpc" "staging" {

  tags = {
    "Terraform" = "True"
    "Environment" = "staging"
  }
  
}