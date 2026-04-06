# quant-infra

Infrastructure as code for the quant agent platform.

## Architecture

```
┌─────────────┐     ┌──────────────────┐     ┌─────────────┐
│   Vercel     │────▶│  AWS ECS Fargate  │────▶│  RDS + Redis │
│  (frontend)  │ SSE │   (backend API)   │     │  (pgvector)  │
└─────────────┘     └──────────────────┘     └─────────────┘
```

## Layers

| Layer | Purpose | State Key |
|-------|---------|-----------|
| bootstrap | S3 + DynamoDB for Terraform state | local → migrated |
| network | VPC, subnets, security groups | network/terraform.tfstate |
| data | RDS PostgreSQL, ElastiCache Redis | data/terraform.tfstate |
| compute | ECR, ECS, ALB | compute/terraform.tfstate |
| cicd | GitHub OIDC, IAM roles, branch protection | cicd/terraform.tfstate |
| vercel | Frontend env var wiring | vercel/terraform.tfstate |

## Getting Started

1. Configure AWS CLI: `aws configure`
2. Run bootstrap: `bash scripts/bootstrap.sh`
3. Apply layers in order: `cd terraform/<layer> && terraform init && terraform apply`
