variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "quant-agent"
}

variable "state_bucket" {
  description = "S3 bucket for Terraform remote state"
  type        = string
}

variable "github_owner" {
  description = "GitHub username"
  type        = string
  default     = "ianalrahwan"
}

variable "github_token" {
  description = "GitHub personal access token for branch protection management"
  type        = string
  sensitive   = true
}

variable "repos" {
  description = "List of repo names to protect"
  type        = list(string)
  default     = ["quant-agent-service", "quant-agent-backend", "quant-infra"]
}
