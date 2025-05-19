#!/bin/zsh

# Check if S3 bucket exists and has versioning enabled
echo "Checking if S3 bucket exists and has versioning enabled..."
BUCKET_NAME=$(grep 'bucket' backend.tfvars | awk -F'"' '{print $2}' | awk -F"'" '{print $2}' | awk '{print $NF}')

if [ -z "$BUCKET_NAME" ]; then
  BUCKET_NAME=$(grep 'bucket' backend.tfvars | awk -F'=' '{print $2}' | tr -d ' ')
fi

echo "Using S3 bucket: $BUCKET_NAME"

# Check if bucket exists
aws s3api head-bucket --bucket $BUCKET_NAME 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Bucket does not exist. Creating bucket..."
  aws s3api create-bucket --bucket $BUCKET_NAME --region us-east-1
  
  echo "Enabling versioning on the bucket..."
  aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled
  
  echo "Enabling server-side encryption..."
  aws s3api put-bucket-encryption --bucket $BUCKET_NAME --server-side-encryption-configuration '{
    "Rules": [
      {
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }
    ]
  }'
  
  echo "Setting public access block..."
  aws s3api put-public-access-block --bucket $BUCKET_NAME --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
else
  echo "Bucket exists, checking versioning status..."
  VERSIONING_STATUS=$(aws s3api get-bucket-versioning --bucket $BUCKET_NAME --query 'Status' --output text)
  
  if [ "$VERSIONING_STATUS" != "Enabled" ]; then
    echo "Enabling versioning on the bucket..."
    aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled
  else
    echo "Versioning is already enabled on the bucket."
  fi
fi

# Initialize Terraform with S3 backend configuration
echo "Initializing Terraform with S3 backend using versioning-based locking..."
terraform init -backend-config=backend.tfvars

# Validate the configuration
echo "Validating Terraform configuration..."
terraform validate

# Show the current plan
echo "Generating Terraform plan..."
terraform plan

echo "\nBackend migration complete! Your state is now stored in S3."
echo "The S3 bucket is: $BUCKET_NAME"
echo "The state file is stored at: networking/terraform.tfstate"
echo "S3 lockfile is enabled to prevent concurrent operations - this is available in Terraform 1.12.0 and later."
echo "S3 versioning is also enabled for additional state safety."
