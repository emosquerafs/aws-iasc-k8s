#!/bin/zsh

# Initialize Terraform with S3 backend configuration
echo "Initializing Terraform with S3 backend..."
terraform init -backend-config=backend.tfvars

# Validate the configuration
echo "Validating Terraform configuration..."
terraform validate

# Show the current plan
echo "Generating Terraform plan..."
terraform plan

echo "\nBackend migration complete! Your state is now stored in S3."
echo "The S3 bucket is: proof-eenee2ma9ohxeiquua2ingaipaz6eerahsugheesaen9asa3fee1koor"
echo "The state file is stored at: networking/terraform.tfstate"
