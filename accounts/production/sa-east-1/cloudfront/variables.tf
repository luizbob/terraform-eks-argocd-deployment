variable "domains" {
  type = list(string)
  description = "Domains to be used on the cdn"
}
variable "name" {
  type = string
  description = "Name of the CDN"
}
variable "price_class" {
  type = string
  description = "Price class of the CDN eg: PriceClass_All or PriceClass_200 or PriceClass_100"
  default = "PriceClass_All"
}
variable "retain_on_delete" {
  type = bool
  description = "Retain cdn after deleted"
  default = false
}
variable "tags" {
  type = map(string)
  description = "Resource tags"
}