resource "aws_ecr_repository" "frontend" {
  name         = "leaderboard-frontend"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "admin" {
  name         = "leaderboard-admin"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = false
  }
}


resource "aws_ecr_repository" "api" {
  name         = "leaderboard-api"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = false
  }
}