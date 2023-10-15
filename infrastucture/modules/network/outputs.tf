output "public_subnet_id" {
    value = aws_subnet.public_subnet[*].id
    description = "Public subnet Ids"
  
}
output "subnet_2_id" {
  value = aws_subnet.private_subnets[*].id
  description = "Private subnet Ids"
}
output "web-ssh-sg-id" {
    value =  join("",aws_security_group.test[*].id)
    description = "Security Group for ssh and web access"
  
}
output "db-sg-id" {
    value = join("",aws_security_group.test_1[*].id)
    description = "Security Group for database access"
    
}
output "dbsng" {
    value = aws_db_subnet_group.db_subnet_grp.name
  
}
