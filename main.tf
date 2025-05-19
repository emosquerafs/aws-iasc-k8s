provider "aws" {
  region = var.aws_region
}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Terraform   = "true"
    Environment = var.environment
    Project     = var.project_name
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  vpc_name          = var.vpc_name
  vpc_cidr          = var.vpc_cidr
  availability_zones = var.availability_zones
  private_subnets   = var.private_subnets
  public_subnets    = var.public_subnets
  
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  
  tags = local.common_tags
}

# Key Pairs Module
module "key_pairs" {
  source = "./modules/key-pairs"
  
  name_prefix = var.vpc_name
  public_keys = var.ssh_public_keys
  
  tags = local.common_tags
}

# Bastion Host Module
module "bastion" {
  source = "./modules/bastion"
  
  vpc_id          = module.vpc.vpc_id
  subnet_id       = module.vpc.public_subnets[0]
  name_prefix     = var.vpc_name
  
  instance_type          = var.bastion_instance_type
  allowed_ssh_cidr_blocks = var.bastion_allowed_cidr_blocks
  key_pair_name          = module.key_pairs.primary_key_name
  create_elastic_ip      = var.bastion_create_elastic_ip
  
  # IAM configuration
  create_iam_instance_profile = var.bastion_create_iam_profile
  iam_role_name               = "${var.vpc_name}-bastion-role"
  iam_role_policies           = var.bastion_iam_policies
  
  user_data = var.bastion_user_data
  
  tags = local.common_tags
}
