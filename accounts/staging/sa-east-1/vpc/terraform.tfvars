name = "staging-vpc"
cidr = "10.0.0.0/16"
azs = [ "sa-east-1a", "sa-east-1b", "sa-east-1c" ]
database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
private_subnets = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
public_subnets = [ "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
tags = {
    "Terraform" = "True"
    "Environment" = "staging"
}