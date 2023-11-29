variable "name" {
  type = string
  description = "Database name"
}
variable "instance_class" {
  type = string
  description = "Instance type eg: db.t3a.large"
}
variable "storage" {
  type = number
  description = "Initial database storage"
  default = 20
}
variable "max_storage" {
  type = number
  description = "Max Allocated storage"
  default = 100
}
variable "username" {
  type = string
  description = "database initial username"
  default = "dbpgsql"
}
variable "tags" {
  type = map(string)
  description = "VPC tags"
}