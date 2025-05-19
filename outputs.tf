# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = module.vpc.public_route_table_ids
}

# Bastion Outputs
output "bastion_id" {
  description = "ID of the bastion instance"
  value       = module.bastion.bastion_id
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion instance"
  value       = module.bastion.bastion_public_ip
}

output "bastion_elastic_ip" {
  description = "Elastic IP address attached to the bastion instance (if created)"
  value       = module.bastion.bastion_elastic_ip
}

output "bastion_security_group_id" {
  description = "ID of the bastion security group"
  value       = module.bastion.bastion_security_group_id
}

output "bastion_ssh_command" {
  description = "SSH command to connect to the bastion host"
  value       = module.bastion.ssh_command
}
