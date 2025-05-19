variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "main-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT gateway for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway for all private subnets"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "SingularIt"
}

# Bastion Host Variables
variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}

variable "bastion_allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to SSH to the bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Open to world by default - restrict in production
}

variable "ssh_public_keys" {
  description = "Map of key names to public key material (the content of your *.pub files)"
  type        = map(string)
  default     = {}
  
  # Example:
  # ssh_public_keys = {
  #   "username" = "ssh-rsa AAAAB3NzaC1yc2EAAA... user@example.com"
  # }
  # 
  # Important: The value should be the entire contents of your public key file (e.g., ~/.ssh/id_rsa.pub)
}

variable "bastion_create_elastic_ip" {
  description = "Whether to create and attach an Elastic IP to the bastion"
  type        = bool
  default     = true
}
