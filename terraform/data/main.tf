terraform {
  required_version = ">= 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "network/terraform.tfstate"
    region = var.aws_region
  }
}

locals {
  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
  rds_sg_id          = data.terraform_remote_state.network.outputs.rds_security_group_id
  redis_sg_id        = data.terraform_remote_state.network.outputs.redis_security_group_id
}

# RDS PostgreSQL + pgvector
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet"
  subnet_ids = local.private_subnet_ids
  tags = { Name = "${var.project_name}-db-subnet" }
}

resource "aws_db_parameter_group" "pgvector" {
  name   = "${var.project_name}-pg16-pgvector"
  family = "postgres16"
}

resource "random_password" "db_password" {
  length  = 32
  special = false
}

resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "${var.project_name}/rds-credentials"
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username = "quantagent"
    password = random_password.db_password.result
  })
}

resource "aws_db_instance" "main" {
  identifier     = "${var.project_name}-db"
  engine         = "postgres"
  engine_version = "16"
  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "quant_agent"
  username = "quantagent"
  password = random_password.db_password.result

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [local.rds_sg_id]
  parameter_group_name   = aws_db_parameter_group.pgvector.name

  backup_retention_period = 7
  skip_final_snapshot     = true
  multi_az                = false
  publicly_accessible     = false

  tags = { Name = "${var.project_name}-db" }
}

# ElastiCache Redis
resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project_name}-redis-subnet"
  subnet_ids = local.private_subnet_ids
}

resource "aws_elasticache_cluster" "main" {
  cluster_id           = "${var.project_name}-redis"
  engine               = "redis"
  engine_version       = "7.1"
  node_type            = var.redis_node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [local.redis_sg_id]
  tags = { Name = "${var.project_name}-redis" }
}

# Secrets Manager: API Keys (placeholders)
resource "aws_secretsmanager_secret" "anthropic_api_key" {
  name = "${var.project_name}/anthropic-api-key"
}

resource "aws_secretsmanager_secret_version" "anthropic_api_key" {
  secret_id     = aws_secretsmanager_secret.anthropic_api_key.id
  secret_string = "REPLACE_ME"
}

resource "aws_secretsmanager_secret" "voyage_api_key" {
  name = "${var.project_name}/voyage-api-key"
}

resource "aws_secretsmanager_secret_version" "voyage_api_key" {
  secret_id     = aws_secretsmanager_secret.voyage_api_key.id
  secret_string = "REPLACE_ME"
}
