# Bastion Host Module

# Security Group for Bastion using the SSH security group module
module "ssh_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "~> 5.0"

  name        = "${var.name_prefix}-bastion-sg"
  description = "Security group for bastion host with SSH access"
  vpc_id      = var.vpc_id
  
  # Only allow SSH access from specified CIDR blocks
  ingress_cidr_blocks = var.allowed_ssh_cidr_blocks
  
  # Add tags
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-bastion-sg"
    }
  )
}

# Note: Key pairs are now managed by the key-pairs module

# Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Bastion Host using the EC2 Instance Module
module "bastion_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name = "${var.name_prefix}-bastion"

  ami                         = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [module.ssh_security_group.security_group_id]
  associate_public_ip_address = true
  user_data                   = var.user_data
  create_eip                  = var.create_elastic_ip
  
  create_iam_instance_profile = var.create_iam_instance_profile
  iam_role_name               = var.iam_role_name
  iam_role_description        = "IAM role for bastion host"
  iam_role_policies           = var.iam_role_policies
  enable_volume_tags          = true
  root_block_device = [
    {
      volume_size           = var.root_volume_size
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  ]

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-bastion"
    }
  )

  instance_tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-bastion"
    }
  )
}
