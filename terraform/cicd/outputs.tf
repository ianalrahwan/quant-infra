output "oidc_provider_arn" {
  value     = aws_iam_openid_connect_provider.github.arn
  sensitive = true
}

output "terraform_plan_role_arn" {
  value     = aws_iam_role.terraform_plan.arn
  sensitive = true
}

output "terraform_apply_role_arn" {
  value     = aws_iam_role.terraform_apply.arn
  sensitive = true
}

output "deploy_backend_role_arn" {
  value     = aws_iam_role.deploy_backend.arn
  sensitive = true
}
