output "database_url" {
  value = aws_db_instance.database.domain_fqdn
}

output "database_username" {
  value = aws_db_instance.database.username
}

output "database_password" {
  value     = aws_db_instance.database.password
  sensitive = true
}

output "bastion" {
  value = aws_instance.bastion.private_ip
}