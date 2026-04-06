terraform {
  required_version = ">= 1.7"

  required_providers {
    vercel = {
      source  = "vercel/vercel"
      version = "~> 2.0"
    }
  }
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

locals {
  backend_url = "http://${data.terraform_remote_state.compute.outputs.alb_dns_name}"
}

resource "vercel_project_environment_variable" "backend_url" {
  project_id = var.vercel_project_id
  key        = "NEXT_PUBLIC_AGENT_BACKEND_URL"
  value      = local.backend_url
  target     = ["production"]
}
