output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "rds_address" {
  value = aws_db_instance.main.address
}

output "rds_port" {
  value = aws_db_instance.main.port
}

output "rds_db_name" {
  value = aws_db_instance.main.db_name
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.main.cache_nodes[0].address
}

output "redis_port" {
  value = aws_elasticache_cluster.main.cache_nodes[0].port
}

output "rds_credentials_secret_arn" {
  value = aws_secretsmanager_secret.rds_credentials.arn
}

output "anthropic_api_key_secret_arn" {
  value = aws_secretsmanager_secret.anthropic_api_key.arn
}

output "voyage_api_key_secret_arn" {
  value = aws_secretsmanager_secret.voyage_api_key.arn
}
