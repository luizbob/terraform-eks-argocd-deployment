module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"
  version = "3.2.1"

  aliases = var.domains

  comment             = var.name
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = var.price_class
  retain_on_delete    = var.retain_on_delete
  wait_for_deployment = false

  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = "Access for cloudfront"
  }
  origin = {
        s3_one = {
            domain_name = module.s3.s3_bucket_bucket_domain_name
            s3_origin_config = {
                origin_access_identity = "s3_bucket_one"
            }
        }
    }
  default_cache_behavior = {
    target_origin_id       = "s3_one"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
  }
  viewer_certificate = {
    acm_certificate_arn = data.aws_acm_certificate.issued.arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2"
  }

  tags = var.tags

  depends_on = [ module.s3 ]
}

module "s3" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = "${var.name}-bucket"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
  tags = var.tags
}