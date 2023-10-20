
# output "instance_id" {
#   value       = aws_instance.test.id
#   description = "The ID of the server"
# }

# output "instance_public_ip" {
#   value = aws_instance.test.public_ip
#   description = "Public IP od EC2 Instance"
  
# }

output "DB_HOST" {
    value = module.aws_db_database.dburl
    description = "DB instance endpoint"
  
}

output "DB_PORT" {
  value = module.aws_db_database.dbport
}

output "DB_USERNAME" {
  value = var.DB_USERNAME
}

output "DB_PASSWORD" {
  value = var.DB_PASSWORD
}


output "WEB_CLIENT_BUCKET_NAME" {
  value = module.aws_website.bucket-name
}

output "WEB_CLIENT_URL" {
  value = module.aws_website.site-url
}

output "ECR_REPOSITORY_NAME" {
  value = module.aws_cluster.ecr_repo_name
}

output "ECR_REPOSITORY_URL" {
  value = module.aws_cluster.ecr_repo_url
}

output "EKS_CLUSTER_NAME" {
    value = module.aws_cluster.cluster_name
  
}
  
output "DB_NAME" {
    value = module.aws_db_database.dbname
  
}