# Uncomment this file second.
# Run the GitHub workflow for Leaderboard admin and frontend containers

data "aws_ecr_image" "frontend" {
  repository_name = aws_ecr_repository.service["frontend"].name
  most_recent     = true
}

resource "aws_apprunner_service" "frontend" {
  service_name = "leaderboard-frontend"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner.arn
    }

    image_repository {
      image_configuration {
        port = "80"
      }
      image_identifier      = data.aws_ecr_image.frontend.image_uri
      image_repository_type = "ECR"
    }

    auto_deployments_enabled = true
  }

  health_check_configuration {
    path     = "/"
    protocol = "HTTP"
  }

  instance_configuration {
    instance_role_arn = aws_iam_role.apprunner_tasks.arn
  }

  network_configuration {
    ingress_configuration {
      is_publicly_accessible = true
    }
  }
}

data "aws_ecr_image" "admin" {
  repository_name = aws_ecr_repository.service["admin"].name
  most_recent     = true
}

resource "aws_apprunner_service" "admin" {
  service_name = "leaderboard-admin"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner.arn
    }

    image_repository {
      image_configuration {
        port = "80"
      }
      image_identifier      = data.aws_ecr_image.admin.image_uri
      image_repository_type = "ECR"
    }

    auto_deployments_enabled = true
  }

  health_check_configuration {
    path     = "/"
    protocol = "HTTP"
  }

  instance_configuration {
    instance_role_arn = aws_iam_role.apprunner_tasks.arn
  }

  network_configuration {
    ingress_configuration {
      is_publicly_accessible = true
    }
  }
}
