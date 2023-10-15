
# output "instance_id" {
#   value       = aws_instance.test.id
#   description = "The ID of the server"
# }

# output "instance_public_ip" {
#   value = aws_instance.test.public_ip
#   description = "Public IP od EC2 Instance"
  
# }

output "rds-db-endpoint" {
    value = aws_db_instance.ra-db.endpoint
    description = "DB instance endpoint"
  
}