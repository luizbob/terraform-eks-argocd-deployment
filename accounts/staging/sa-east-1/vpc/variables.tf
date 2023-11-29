variable "name" {
    type = string
    description = "VPC Name"
}
variable "region" {
  type = string
  description = "Aws region"
  default = "sa-east-1"
}
variable "azs" {
  type = list(string)
  description = "List of all AZs"
}
variable "cidr" {
  type = string
  description = "VPC CIDR"
}
variable "private_subnets" {
  type = list(string)
  description = "Private subnets CIDRs"
}
variable "database_subnets" {
  type = list(string)
  description = "Database subnets CIDRs"
}
variable "public_subnets" {
  type = list(string)
  description = "Public Subnet CIDRs"
}
variable "tags" {
  type = map(string)
  description = "VPC tags"
}