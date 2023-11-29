variable "cluster_name" {
  type = string
  description = "Eks cluster name"
}
variable "cluster_version" {
  type = string
  description = "Eks cluster kubernetes version"
  default = "1.27"
}
variable "private_ng_max_size" {
  type = number
  description = "Max node number private ng"
}
variable "private_ng_min_size" {
  type = number
  description = "Min node number private ng"
}
variable "public_ng_max_size" {
  type = number
  description = "Max node number public ng"
}
variable "public_ng_min_size" {
  type = number
  description = "Min node number public ng"
}
variable "tags" {
  type = map(string)
  description = "Resource tags"
}