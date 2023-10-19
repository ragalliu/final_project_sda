resource "aws_s3_bucket" "ra_static_site" {
  bucket = "${APP_NAME}-static-site-bucket"

}


resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket = aws_s3_bucket.ra_static_site.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "site_policy" {
bucket = aws_s3_bucket.ra_static_site.id
policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"PublicReadGetObject",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["${aws_s3_bucket.ra_static_site.arn}/*"]
    }
  ]
}
POLICY
} 

resource "aws_s3_bucket_website_configuration" "ra" {
  bucket = aws_s3_bucket.ra_static_site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}
# resource "aws_s3_object" "object" {
  
#    for_each = {
#     "index.html" = "/home/gerti/Downloads/index.html"
#     "error.html" = "/home/gerti/Downloads/error.html"
#   }
#   bucket = aws_s3_bucket.ra_static_site.id
#   key = each.key
#   source = each.value

  
# }