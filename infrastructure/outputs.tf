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

output "app_database" {
  value = {
    username = random_pet.leaderboard_database.id
    password = random_password.leaderboard_database.result
  }
  sensitive = true
}