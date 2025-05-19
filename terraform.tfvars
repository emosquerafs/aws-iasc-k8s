# General settings
aws_region   = "us-east-1"
environment  = "dev"
project_name = "SingularIt"

# VPC settings
vpc_name          = "wipa-vpc"
vpc_cidr          = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
enable_nat_gateway = true
single_nat_gateway = true

# Bastion settings
bastion_instance_type = "t3.micro"
bastion_allowed_cidr_blocks = ["0.0.0.0/0"] # Replace with your IP range for better security
bastion_create_elastic_ip = true
# Generate a key pair with: ssh-keygen -t rsa -b 4096 -f ~/.ssh/wipa_bastion
# Then add your public key below
bastion_public_key = "" # Add your public key here, e.g., "ssh-rsa AAAAB3NzaC1yc2EAA..."
