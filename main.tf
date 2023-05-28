locals {
  project = "lorenzosfienti-dev-backup"
  domain  = "backup.lorenzosfienti.dev"
}


# Modulo per creare un bucket
module "bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = local.project
}

# Modulo per creare una CDN per l'accesso al bucket. Il bucket direttamente non sarà accessibile

module "cdn" {
  source              = "terraform-aws-modules/cloudfront/aws"
  aliases             = [local.domain]
  comment             = local.project
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_identity = true
  origin_access_identities = {
    bucket = local.project
  }

  origin = {
    bucket = {
      domain_name = module.bucket.s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "bucket"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "bucket"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
    function_association = {
      viewer-request = {
        function_arn = aws_cloudfront_function.check.arn
      }
    }
  }
  viewer_certificate = {
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
  depends_on = [module.acm]
}

resource "aws_cloudfront_function" "check" {
  name    = "${local.project}-check"
  runtime = "cloudfront-js-1.0"
  code    = templatefile("functions/check-request.js",{
    access_key = module.iam.iam_access_key_id,
    access_secret = module.iam.iam_access_key_secret
    url = "https://${local.domain}"
  })
}

# Modulo per aggiungere alla policy di accesso al bucket la CDN

module "bucket_policy" {
  source                                     = "./modules/bucket-cdn"
  cloudfront_origin_access_identity_iam_arns = module.cdn.cloudfront_origin_access_identity_iam_arns
  bucket_assets_id                           = module.bucket.s3_bucket_id
}



module "acm" {
  source                 = "terraform-aws-modules/acm/aws"
  version                = "~> 4.0"
  domain_name            = local.domain
  create_route53_records = false
}
