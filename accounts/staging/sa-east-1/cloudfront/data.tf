data "aws_acm_certificate" "issued" {
  domain   = "descoshop.staging.com.br"
  statuses = ["ISSUED"]
}