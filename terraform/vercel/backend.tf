terraform {
  backend "s3" {
    bucket         = "PLACEHOLDER_BUCKET"
    key            = "vercel/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "quant-infra-tflock"
    encrypt        = true
  }
}
