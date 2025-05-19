# Bastion Host Module

# Security Group for Bastion
resource "aws_security_group" "bastion" {
  name        = "${var.name_prefix}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_blocks
    description = "SSH access from specified IPs"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

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

# Bastion Host EC2 Instance
resource "aws_instance" "bastion" {
  ami                         = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  user_data                   = var.user_data

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-bastion"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Elastic IP for Bastion
resource "aws_eip" "bastion" {
  count    = var.create_elastic_ip ? 1 : 0
  domain   = "vpc"
  instance = aws_instance.bastion.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-bastion-eip"
    }
  )
}
