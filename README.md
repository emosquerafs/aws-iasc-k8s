# SingularIt Networking Infrastructure

This repository contains Terraform code for deploying and managing AWS VPC infrastructure for SingularIt projects.

## Infrastructure Components

- **VPC**: A Virtual Private Cloud with custom CIDR block
- **Subnets**: Multiple public and private subnets across different availability zones
- **NAT Gateway**: For outbound internet access from private subnets
- **Internet Gateway**: For inbound/outbound internet access from public subnets
- **Route Tables**: For controlling traffic flow
- **Key Pairs**: SSH key pairs for secure access management
- **Bastion Host**: Secure entry point to the private resources within the VPC

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.0 or higher)
- AWS CLI configured with appropriate credentials
- Access to AWS account with permissions to create networking resources

### Initial Setup

1. Clone this repository
2. Create a `terraform.tfvars` file with required variables (see next section)
3. Initialize Terraform with the S3 backend:

```bash
# Either run the initialization script
./init-backend.sh

# Or initialize manually
terraform init -backend-config=backend.tfvars
```

4. Verify the plan:

```bash
terraform plan
```

5. Apply the configuration:

```bash
terraform apply
```

### Remote State Configuration

This project uses an S3 bucket for remote state storage with S3 lockfile-based state locking (available in Terraform 1.12.0). The configuration is stored in `backend.tfvars` file:

```hcl
region       = "us-east-1"
bucket       = "wipa-terraform-backend"
key          = "networking/terraform.tfstate"
encrypt      = true
use_lockfile = true  # Enables state file locking using an S3 lock file
```

Benefits of using remote state with S3 lockfile:
- Team collaboration: Multiple team members can work on the infrastructure
- State locking: Prevents concurrent operations that could corrupt state
- Security: State is encrypted at rest in S3
- Secure storage: State file is encrypted at rest in S3
- Versioning: S3 bucket versioning preserves previous states
- Backup: S3 provides reliable backup for your state file

### Required terraform.tfvars File

Since the tfvars file is excluded from version control for security reasons, you'll need to create one. Create a file named `terraform.tfvars` with the following content (adjust values as needed):

```hcl
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
bastion_instance_type = "t3.nano"
bastion_allowed_cidr_blocks = ["YOUR_IP_ADDRESS/32"]  # Replace with your IP address
bastion_create_elastic_ip = true
bastion_create_iam_profile = false
bastion_iam_policies = {
  # "AmazonS3ReadOnlyAccess" = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
bastion_user_data = ""

# SSH key pairs
# Map of key names to public key material
ssh_public_keys = {
  "your_username" = "YOUR_SSH_PUBLIC_KEY"  # Replace with your SSH public key
  # Add more keys as needed following the same pattern:
  # "username" = "ssh-rsa ..."
}

# DNS settings
create_dns_record = true                 # Set to true to create DNS record
hosted_zone_name  = "singularit.co"      # Your Route53 hosted zone name
private_zone      = false                # Set to true if using a private hosted zone
bastion_dns_name  = "wipa-bastion"       # Subdomain name (creates wipa-bastion.singularit.co)
```

**Important**: 
- Replace `YOUR_IP_ADDRESS/32` with your actual IP address to restrict SSH access
- Replace `your_username` with your actual username
- Replace `YOUR_SSH_PUBLIC_KEY` with your actual SSH public key (from your `~/.ssh/id_rsa.pub` file or equivalent)

## Configuration Options

You can customize the deployment by modifying the variables in `terraform.tfvars`:

- `aws_region`: AWS region to deploy the infrastructure
- `vpc_name`: Name of the VPC
- `vpc_cidr`: CIDR block for the VPC
- `availability_zones`: List of AZs to use
- `private_subnets`: CIDR blocks for private subnets
- `public_subnets`: CIDR blocks for public subnets
- `ssh_public_keys`: Map of key names to public key material for SSH access
- `bastion_instance_type`: EC2 instance type for the bastion host
- `bastion_allowed_cidr_blocks`: CIDR blocks allowed to SSH to the bastion
- `bastion_create_elastic_ip`: Whether to create an Elastic IP for the bastion
- `bastion_create_iam_profile`: Whether to create an IAM instance profile
- `bastion_iam_policies`: Map of IAM policies to attach to the bastion role
- `bastion_user_data`: User data script for the bastion instance
- `enable_nat_gateway`: Whether to create NAT Gateway
- `single_nat_gateway`: Use single NAT Gateway for all AZs
- `environment`: Environment name (e.g., dev, staging, prod)
- `project_name`: Project name for tagging
- `create_dns_record`: Whether to create a DNS record for the bastion
- `hosted_zone_name`: Route53 hosted zone name
- `private_zone`: Whether the hosted zone is private
- `bastion_dns_name`: Subdomain name for the bastion DNS record

## Project Structure

This project is organized in a modular structure to enable reusability and maintainability:

```
.
├── main.tf              # Main configuration file that combines all modules
├── variables.tf         # Input variables for the root module
├── outputs.tf           # Output values from the root module
├── terraform.tfvars     # Variable values for your specific deployment
├── versions.tf          # Terraform and provider version constraints
└── modules/             # Directory containing all the module definitions
    ├── vpc/             # VPC network infrastructure module
    ├── key-pairs/       # SSH key pairs management module
    └── bastion/         # Bastion host module
```

### Module Descriptions

1. **VPC Module**: Creates a Virtual Private Cloud with public and private subnets, NAT Gateway, Internet Gateway, and route tables.
2. **Key Pairs Module**: Manages multiple SSH key pairs for secure access to EC2 instances.
3. **Bastion Module**: Creates a secure bastion host in a public subnet using the terraform-aws-modules/ec2-instance/aws module. The bastion uses SSH keys from the key-pairs module and can be configured with IAM roles, user data, and other advanced options.
4. **Route53 Module**: Creates DNS records for the bastion host.

## DNS Configuration

The infrastructure supports creating a DNS record for the bastion host using Route53. To configure DNS:

1. Make sure you have a Route53 hosted zone set up for your domain (e.g., `singularit.co`)
2. In your `terraform.tfvars` file, set the following variables:

```hcl
# DNS settings
create_dns_record = true                 # Set to true to create DNS record
hosted_zone_name  = "singularit.co"      # Your Route53 hosted zone name
private_zone      = false                # Set to true if using a private hosted zone
bastion_dns_name  = "wipa-bastion"       # Subdomain name (creates wipa-bastion.singularit.co)
```

3. After applying the Terraform configuration, you can access your bastion host using either:
   - The public IP address: `ssh ec2-user@<BASTION_IP>`
   - The DNS name: `ssh ec2-user@wipa-bastion.singularit.co`

The DNS record will automatically update if the bastion's IP address changes (e.g., if you recreate the instance).

## Outputs

After applying the configuration, you can use the following outputs:

- `vpc_id`: ID of the created VPC
- `vpc_cidr_block`: CIDR block of the VPC
- `private_subnets`: IDs of private subnets
- `public_subnets`: IDs of public subnets
- `nat_public_ips`: Public IPs of NAT Gateways
- `private_route_table_ids`: IDs of private route tables
- `public_route_table_ids`: IDs of public route tables
- `bastion_id`: ID of the bastion instance
- `bastion_arn`: ARN of the bastion instance
- `bastion_public_ip`: Public IP of the bastion host
- `bastion_elastic_ip`: Elastic IP of the bastion host (if enabled)
- `bastion_security_group_id`: ID of the security group attached to the bastion
- `bastion_iam_role_name`: Name of the IAM role attached to the bastion (if enabled)
- `bastion_ssh_command`: SSH command to connect to the bastion
- `key_pair_names`: Map of key names to AWS key pair names
