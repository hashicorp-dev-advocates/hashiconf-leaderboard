resource "random_pet" "leaderboard_database" {
  length = 2
}

resource "random_password" "leaderboard_database" {
  length           = 24
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 1
  special          = false
  override_special = "*@"
}

resource "aws_secretsmanager_secret" "leaderboard_database" {
  name = "${var.name}-leaderboard-database"
}

resource "aws_secretsmanager_secret_version" "leaderboard_database" {
  secret_id     = aws_secretsmanager_secret.leaderboard_database.id
  secret_string = "host=${aws_db_instance.database.address} port=5432 user=${aws_db_instance.database.username} password=${aws_db_instance.database.password} dbname=leaderboard connect_timeout=10"
}