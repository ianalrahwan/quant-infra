terraform {
  backend "s3" {
    bucket         = "quant-infra-tfstate-126000553768"
    key            = "network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "quant-infra-tflock"
    encrypt        = true
  }
}
