resource "aws_iam_role" "apprunner_build" {
  name = "${var.name}-apprunner-build"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "apprunner_ecr" {
  name = "${var.name}-apprunner-ecr"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:GetAuthorizationToken"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_ecr" {
  role       = aws_iam_role.apprunner_build.name
  policy_arn = aws_iam_policy.apprunner_ecr.arn
}

resource "aws_iam_role" "apprunner_tasks" {
  name = "${var.name}-apprunner-tasks"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "apprunner_secrets" {
  name = "${var.name}-apprunner-secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Effect = "Allow"
        Resource = [
          aws_secretsmanager_secret.leaderboard_database.arn
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_tasks" {
  role       = aws_iam_role.apprunner_tasks.name
  policy_arn = aws_iam_policy.apprunner_secrets.arn
}