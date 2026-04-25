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
          Federated = var.github_oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo_owner}/${var.github_repo_name}:ref:refs/heads/${var.github_repo_branch}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_deploy" {
  name = "github-actions-ecs-deploy-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_push" {
  name = "github-actions-ecr-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.ecs_deploy.arn
}

resource "aws_iam_role_policy_attachment" "ecr_attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.ecr_push.arn
}

# Note: github_actions_policy was removed - it duplicated ecs_deploy and ecr_push permissions
