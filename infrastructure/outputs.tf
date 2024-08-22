output "database_url" {
  value = aws_db_instance.database.address
}

output "database_username" {
  value = aws_db_instance.database.username
}

output "database_password" {
  value     = aws_db_instance.database.password
  sensitive = true
}