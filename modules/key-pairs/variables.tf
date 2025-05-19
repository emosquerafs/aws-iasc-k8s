variable "name_prefix" {
  description = "Prefix to use for key pair names"
  type        = string
  default     = "wipa"
}

variable "public_keys" {
  description = "Map of key names to public key material (the content of your *.pub files)"
  type        = map(string)
  default     = {}
  
  # Example:
  # public_keys = {
  #   "user1" = "ssh-rsa AAAAB3NzaC1yc2EAAA... user1@example.com"
  #   "user2" = "ssh-rsa AAAAB3NzaC1yc2EAAA... user2@example.com"
  # }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
