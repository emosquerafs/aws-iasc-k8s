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

# Key Pairs Outputs
output "key_pair_names" {
  description = "Map of key names to key pair names in AWS"
  value       = module.key_pairs.key_pair_names
}

output "primary_key_name" {
  description = "Name of the primary key pair used for the bastion"
  value       = module.key_pairs.primary_key_name
}

# DNS Outputs
output "bastion_dns_name" {
  description = "DNS name of the bastion host"
  value       = var.create_dns_record ? module.bastion_dns[0].fqdn : null
}

output "hosted_zone_id" {
  description = "ID of the hosted zone used for DNS records"
  value       = var.create_dns_record ? module.bastion_dns[0].zone_id : null
}

output "bastion_ssh_command_dns" {
  description = "SSH command to connect to the bastion host using DNS name"
  value       = var.create_dns_record ? "ssh ec2-user@${module.bastion_dns[0].record_name}" : null
}

# Delegated Zones Outputs
output "delegated_zone_ids" {
  description = "Map of environment names to their hosted zone IDs"
  value       = var.create_delegated_zones ? module.delegated_zones[0].zone_ids : null
}

output "delegated_zone_name_servers" {
  description = "Map of environment names to their name servers"
  value       = var.create_delegated_zones ? module.delegated_zones[0].name_servers : null
}

output "delegated_zone_fqdns" {
  description = "Map of environment names to their fully qualified domain names"
  value       = var.create_delegated_zones ? module.delegated_zones[0].fqdns : null
}

output "environment_service_records" {
  description = "Map of service record FQDNs created in the delegated zones"
  value       = var.create_delegated_zones && length(var.environment_service_records) > 0 ? module.delegated_zones[0].service_record_fqdns : null
}
