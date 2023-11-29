data "aws_acm_certificate" "issued" {
  domain   = "descoshop.com.br"
  statuses = ["ISSUED"]
}