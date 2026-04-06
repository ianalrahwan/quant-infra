output "rds_endpoint" {
  value     = aws_db_instance.main.endpoint
  sensitive = true
}

output "rds_address" {
  value     = aws_db_instance.main.address
  sensitive = true
}

output "rds_port" {
  value     = aws_db_instance.main.port
  sensitive = true
}

output "rds_db_name" {
  value     = aws_db_instance.main.db_name
  sensitive = true
}

output "redis_endpoint" {
  value     = aws_elasticache_cluster.main.cache_nodes[0].address
  sensitive = true
}

output "redis_port" {
  value     = aws_elasticache_cluster.main.cache_nodes[0].port
  sensitive = true
}

output "rds_credentials_secret_arn" {
  value     = aws_secretsmanager_secret.rds_credentials.arn
  sensitive = true
}

output "anthropic_api_key_secret_arn" {
  value     = aws_secretsmanager_secret.anthropic_api_key.arn
  sensitive = true
}

output "voyage_api_key_secret_arn" {
  value     = aws_secretsmanager_secret.voyage_api_key.arn
  sensitive = true
}
