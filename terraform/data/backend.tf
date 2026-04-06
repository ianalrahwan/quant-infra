terraform {
  backend "s3" {
    bucket         = "quant-infra-tfstate-126000553768"
    key            = "data/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "quant-infra-tflock"
    encrypt        = true
  }
}
