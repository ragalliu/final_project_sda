output "bucket-name" {
    value = aws_s3_bucket.ra_static_site.id
  
}

output "site-url" {
    value = aws_s3_bucket_website_configuration.ra.website_endpoint
  
}