data "aws_s3_bucket" "bucket" {
  bucket = var.bucket_assets_id
}

data "aws_iam_policy_document" "bucket_s3_policy" {
  statement {
    sid       = "1"
    actions   = ["s3:GetObject"]
    resources = ["${data.aws_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = var.cloudfront_origin_access_identity_iam_arns
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = data.aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.bucket_s3_policy.json
}