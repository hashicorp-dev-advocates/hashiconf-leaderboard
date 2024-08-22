data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "service" {
  for_each     = var.leaderboard_services
  name         = "leaderboard-${each.value}"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "github_actions_variable" "service" {
  for_each      = var.leaderboard_services
  repository    = var.github_repository
  variable_name = each.value
  value         = aws_ecr_repository.service[each.value].repository_url
}

resource "github_actions_variable" "aws_account_id" {
  repository    = var.github_repository
  variable_name = "AWS_ACCOUNT_ID"
  value         = data.aws_caller_identity.current.account_id
}