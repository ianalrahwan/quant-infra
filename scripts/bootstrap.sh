#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOTSTRAP_DIR="${SCRIPT_DIR}/../terraform/bootstrap"

echo "=== Quant Infra Bootstrap ==="
echo ""

echo "Step 1: Initializing Terraform (local state)..."
cd "${BOOTSTRAP_DIR}"
terraform init

echo ""
echo "Step 2: Creating state backend resources..."
terraform apply

BUCKET=$(terraform output -raw state_bucket_name)
ACCOUNT_ID=$(terraform output -raw aws_account_id)
echo ""
echo "State bucket: ${BUCKET}"
echo "Account ID: ${ACCOUNT_ID}"

echo ""
echo "Step 3: Configuring S3 backend..."
cat > backend.tf << EOF
terraform {
  backend "s3" {
    bucket         = "${BUCKET}"
    key            = "bootstrap/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "quant-infra-tflock"
    encrypt        = true
  }
}
EOF

echo ""
echo "Step 4: Migrating state to S3..."
terraform init -migrate-state -force-copy

echo ""
echo "Step 5: Cleaning up local state files..."
rm -f terraform.tfstate terraform.tfstate.backup

echo ""
echo "=== Bootstrap complete! ==="
echo "State bucket: ${BUCKET}"
echo "Lock table: quant-infra-tflock"
