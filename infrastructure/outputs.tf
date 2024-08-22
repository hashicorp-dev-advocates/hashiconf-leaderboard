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

output "repositories" {
  value = {
    frontend = aws_ecr_repository.frontend.repository_url
    admin    = aws_ecr_repository.admin.repository_url
    api      = aws_ecr_repository.api.repository_url
  }
}