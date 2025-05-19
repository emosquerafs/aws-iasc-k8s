output "bastion_id" {
  description = "ID of the bastion instance"
  value       = aws_instance.bastion.id
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion instance"
  value       = aws_instance.bastion.public_ip
}

output "bastion_elastic_ip" {
  description = "Elastic IP address attached to the bastion instance (if created)"
  value       = var.create_elastic_ip ? aws_eip.bastion[0].public_ip : null
}

output "bastion_security_group_id" {
  description = "ID of the bastion security group"
  value       = aws_security_group.bastion.id
}

output "ssh_command" {
  description = "SSH command to connect to the bastion host"
  value       = "ssh ec2-user@${var.create_elastic_ip ? aws_eip.bastion[0].public_ip : aws_instance.bastion.public_ip}"
}
