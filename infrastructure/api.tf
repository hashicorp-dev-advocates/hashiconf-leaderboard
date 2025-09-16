## Uncomment this file first.
## Run the GitHub workflow for Leaderboard api container

data "aws_ecr_image" "api" {
  repository_name = aws_ecr_repository.service["api"].name
  most_recent     = true
}

resource "aws_apprunner_service" "api" {
  service_name = "leaderboard-api"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner.arn
    }

    image_repository {
      image_configuration {
        port = "9090"
        runtime_environment_secrets = {
          DB_CONNECTION = aws_secretsmanager_secret.leaderboard_database.arn
        }
      }
      image_identifier      = data.aws_ecr_image.api.image_uri
      image_repository_type = "ECR"
    }

    auto_deployments_enabled = true
  }

  health_check_configuration {
    path     = "/health/livez"
    protocol = "HTTP"
  }

  instance_configuration {
    instance_role_arn = aws_iam_role.apprunner_tasks.arn
  }

  network_configuration {
    ingress_configuration {
      is_publicly_accessible = true
    }

    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.connector.arn
    }
  }
}

resource "github_actions_variable" "leaderboard_api" {
  repository    = var.github_repository
  variable_name = "LEADERBOARD_API"
  value         = "https://${aws_apprunner_service.api.service_url}"
}
