# Uncomment after first apply, then run: terraform init -migrate-state
#
# terraform {
#   backend "s3" {
#     bucket         = "quant-infra-tfstate-ACCOUNT_ID"
#     key            = "bootstrap/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "quant-infra-tflock"
#     encrypt        = true
#   }
# }
