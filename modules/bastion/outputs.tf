output "bastion_id" {
  description = "ID of the bastion instance"
  value       = module.bastion_instance.id
}

output "bastion_arn" {
  description = "ARN of the bastion instance"
  value       = module.bastion_instance.arn
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion instance"
  value       = module.bastion_instance.public_ip
}

output "bastion_elastic_ip" {
  description = "Elastic IP address attached to the bastion instance (if created)"
  value       = var.create_elastic_ip ? module.bastion_instance.public_ip : null
}

output "bastion_security_group_id" {
  description = "ID of the bastion security group"
  value       = module.ssh_security_group.security_group_id
}

output "bastion_iam_role_name" {
  description = "IAM role name of the bastion instance"
  value       = var.create_iam_instance_profile ? module.bastion_instance.iam_role_name : null
}

output "ssh_command" {
  description = "SSH command to connect to the bastion host"
  value       = "ssh ec2-user@${module.bastion_instance.public_ip}"
}
