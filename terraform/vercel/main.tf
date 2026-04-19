terraform {
  required_version = ">= 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    vercel = {
      source  = "vercel/vercel"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "vercel" {
  api_token = var.vercel_api_token
}

data "terraform_remote_state" "compute" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "compute/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "data" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "data/terraform.tfstate"
    region = var.aws_region
  }
}

data "aws_secretsmanager_secret_version" "agent_access_password" {
  secret_id = data.terraform_remote_state.data.outputs.agent_access_password_secret_arn
}
data "aws_secretsmanager_secret_version" "session_cookie_secret" {
  secret_id = data.terraform_remote_state.data.outputs.session_cookie_secret_secret_arn
}
data "aws_secretsmanager_secret_version" "pro_tier_token" {
  secret_id = data.terraform_remote_state.data.outputs.pro_tier_token_secret_arn
}

locals {
  backend_url = "http://${data.terraform_remote_state.compute.outputs.alb_dns_name}"
}

resource "vercel_project_environment_variable" "backend_url" {
  project_id = var.vercel_project_id
  key        = "NEXT_PUBLIC_AGENT_BACKEND_URL"
  value      = local.backend_url
  target     = ["production"]
}

resource "vercel_project_environment_variable" "agent_access_password" {
  project_id = var.vercel_project_id
  key        = "AGENT_ACCESS_PASSWORD"
  value      = data.aws_secretsmanager_secret_version.agent_access_password.secret_string
  target     = ["production", "preview"]
  sensitive  = true
}
resource "vercel_project_environment_variable" "session_cookie_secret" {
  project_id = var.vercel_project_id
  key        = "SESSION_COOKIE_SECRET"
  value      = data.aws_secretsmanager_secret_version.session_cookie_secret.secret_string
  target     = ["production", "preview"]
  sensitive  = true
}
resource "vercel_project_environment_variable" "pro_tier_token" {
  project_id = var.vercel_project_id
  key        = "PRO_TIER_TOKEN"
  value      = data.aws_secretsmanager_secret_version.pro_tier_token.secret_string
  target     = ["production", "preview"]
  sensitive  = true
}
