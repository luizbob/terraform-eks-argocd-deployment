name = "production"
cidr = "10.1.0.0/16"
azs = [ "sa-east-1a", "sa-east-1b", "sa-east-1c" ]
database_subnets = ["10.1.21.0/24", "10.1.22.0/24", "10.1.23.0/24"]
private_subnets = [ "10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24" ]
public_subnets = [ "10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
tags = {
    "Terraform" = "True"
    "Environment" = "production"
}