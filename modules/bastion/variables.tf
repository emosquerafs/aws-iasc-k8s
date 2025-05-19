variable "vpc_id" {
  description = "ID of the VPC where the bastion will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "ID of the public subnet where the bastion will be deployed"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
  default     = "wipa"
}

variable "instance_type" {
  description = "EC2 instance type for the bastion"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the bastion host (defaults to latest Amazon Linux 2 if empty)"
  type        = string
  default     = ""
}

variable "allowed_ssh_cidr_blocks" {
  description = "List of CIDR blocks allowed to SSH to the bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Open to world by default - CHANGE THIS IN PRODUCTION!
}

variable "key_pair_name" {
  description = "Name of the key pair to use with the bastion (must exist in AWS)"
  type        = string
}

variable "create_elastic_ip" {
  description = "Whether to create and attach an Elastic IP to the bastion"
  type        = bool
  default     = true
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 10
}

variable "user_data" {
  description = "User data script to run on instance start"
  type        = string
  default     = ""
}

variable "create_iam_instance_profile" {
  description = "Whether to create an IAM instance profile for the bastion"
  type        = bool
  default     = false
}

variable "iam_role_name" {
  description = "Name of the IAM role to attach to the bastion (if create_iam_instance_profile is true)"
  type        = string
  default     = ""
}

variable "iam_role_policies" {
  description = "IAM policies to attach to the bastion role"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
