# Quant Infra

## Project

Terraform infrastructure for the quant agent platform. Manages AWS (ECS, RDS, Redis, VPC), CI/CD (GitHub OIDC), and cross-platform wiring (Vercel env vars).

## Layer Order

bootstrap → network → data → compute → cicd → vercel

## Commands

- `cd terraform/<layer> && terraform init` — initialize a layer
- `cd terraform/<layer> && terraform plan` — preview changes
- `cd terraform/<layer> && terraform apply` — apply changes
- `bash scripts/bootstrap.sh` — one-time state backend setup

## Workflow

- All changes via PR to main
- `terraform-plan.yml` runs on PR, posts plan as comment
- `terraform-apply.yml` runs on merge to main, applies in order
- Never apply manually in production — always through CI
