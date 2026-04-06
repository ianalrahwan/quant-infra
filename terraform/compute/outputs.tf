output "alb_dns_name" {
  value     = aws_lb.main.dns_name
  sensitive = true
}

output "alb_arn" {
  value     = aws_lb.main.arn
  sensitive = true
}

output "ecr_repository_url" {
  value     = aws_ecr_repository.backend.repository_url
  sensitive = true
}

output "ecs_cluster_name" {
  value     = aws_ecs_cluster.main.name
  sensitive = true
}

output "ecs_api_service_name" {
  value     = aws_ecs_service.api.name
  sensitive = true
}
