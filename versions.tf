terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  # Uncomment the following block if you want to use a remote backend
  # backend "s3" {
  #   bucket         = "singularit-terraform-state"
  #   key            = "infrastructure/networking/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-locks"
  # }
}
