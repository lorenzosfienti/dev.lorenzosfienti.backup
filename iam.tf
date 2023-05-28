# Modulo per creare lo user con relativa access_key e access_secret

module "iam" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-user"
  name                          = local.project
  create_iam_user_login_profile = false
  create_iam_access_key         = true
}

# Policy document per l'accesso in scrittura e lettura del bucket

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "1"

    actions = [
      "s3:*",
    ]

    resources = [
      module.bucket.s3_bucket_arn
    ]
  }
}

resource "aws_iam_policy" "bucket_policy" {
  name   = local.project
  path   = "/"
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_iam_user_policy_attachment" "bucket_policy_attachment" {
  user       = module.iam.iam_user_name
  policy_arn = aws_iam_policy.bucket_policy.arn
}