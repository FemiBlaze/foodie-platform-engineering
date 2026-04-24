locals {
  github_oidc_subject = format(
    "repo:%s/%s:ref:refs/heads/%s",
    var.github_repo_owner,
    var.github_repo_name,
    var.github_repo_branch
  )
}

resource "aws_iam_openid_connect_provider" "github" {
  url = var.github_oidc_provider_url

  client_id_list = [var.github_oidc_client_id]

  thumbprint_list = [var.github_oidc_thumbprint]
}

resource "aws_iam_role" "github_actions" {
  name = var.github_oidc_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = local.github_oidc_subject
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "github_actions_policy" {
  name = var.github_oidc_policy_name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_attachment" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}
