# SingularIt Networking Infrastructure

This repository contains Terraform code for deploying and managing AWS VPC infrastructure for SingularIt projects.

## Infrastructure Components

- **VPC**: A Virtual Private Cloud with custom CIDR block
- **Subnets**: Multiple public and private subnets across different availability zones
- **NAT Gateway**: For outbound internet access from private subnets
- **Internet Gateway**: For inbound/outbound internet access from public subnets
- **Route Tables**: For controlling traffic flow

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.0 or higher)
- AWS CLI configured with appropriate credentials
- Access to AWS account with permissions to create networking resources

### Initial Setup

1. Clone this repository
2. Update variables in `terraform.tfvars` if needed
3. Initialize Terraform:

```bash
terraform init
```

4. Verify the plan:

```bash
terraform plan
```

5. Apply the configuration:

```bash
terraform apply
```

## Configuration Options

You can customize the deployment by modifying the variables in `terraform.tfvars`:

- `aws_region`: AWS region to deploy the infrastructure
- `vpc_name`: Name of the VPC
- `vpc_cidr`: CIDR block for the VPC
- `availability_zones`: List of AZs to use
- `private_subnets`: CIDR blocks for private subnets
- `public_subnets`: CIDR blocks for public subnets
- `enable_nat_gateway`: Whether to create NAT Gateway
- `single_nat_gateway`: Use single NAT Gateway for all AZs
- `environment`: Environment name (e.g., dev, staging, prod)
- `project_name`: Project name for tagging

## Outputs

After applying the configuration, you can use the following outputs:

- `vpc_id`: ID of the created VPC
- `vpc_cidr_block`: CIDR block of the VPC
- `private_subnets`: IDs of private subnets
- `public_subnets`: IDs of public subnets
- `nat_public_ips`: Public IPs of NAT Gateways
- `private_route_table_ids`: IDs of private route tables
- `public_route_table_ids`: IDs of public route tables
