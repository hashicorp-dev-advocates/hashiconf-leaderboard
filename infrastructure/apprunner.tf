data "aws_ecr_image" "services" {
  for_each        = var.leaderboard_services
  repository_name = aws_ecr_repository.service[each.value].name
  most_recent     = true
}

resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "${var.name}-leaderboard"
  subnets            = module.vpc.private_subnets
  security_groups    = [aws_security_group.database.id]
}

resource "aws_apprunner_service" "api" {
  service_name = "leaderboard-api"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_build.arn
    }

    image_repository {
      image_configuration {
        port = "9090"
        runtime_environment_secrets = {
          DB_CONNECTION = aws_secretsmanager_secret.leaderboard_database.arn
        }
      }
      image_identifier      = data.aws_ecr_image.services["api"].image_uri
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