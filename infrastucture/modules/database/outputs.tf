output "dbname" {
    value = aws_db_instance.ra-db.db_name
  
}

output "dburl" {
    value = aws_db_instance.ra-db.address
  
}
output "dbpasswd" {
    value = aws_db_instance.ra-db.password
  
}
output "dbuser" {
    value = aws_db_instance.ra-db.username
  
}
output "dbport" {
    value = aws_db_instance.ra-db.port
  
}