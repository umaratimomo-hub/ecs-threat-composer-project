# 1. Create the OIDC Provider for GitHub
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  # Standard thumbprints for GitHub Actions
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

# 2. Create the IAM Role that GitHub will assume
resource "aws_iam_role" "github_actions_terraform" {
  name = "github-actions-terraform-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          # Only allow this repository to assume this role
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:umaratimomo-hub/ecs-threat-composer-project:*"
          }
        }
      }
    ]
  })
}

# 3. Attach Administrator Permissions to the Role
resource "aws_iam_role_policy_attachment" "github_actions_admin" {
  role       = aws_iam_role.github_actions_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# 4. Output the Role ARN to copy to GitHub
output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions_terraform.arn
  description = "The ARN of the IAM Role to use in GitHub Actions"
}
