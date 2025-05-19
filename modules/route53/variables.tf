variable "hosted_zone_name" {
  description = "The name of the hosted zone where the DNS record will be created"
  type        = string
}

variable "private_zone" {
  description = "Whether the hosted zone is private"
  type        = bool
  default     = false
}

variable "dns_record_name" {
  description = "The name of the DNS record to create (without the domain)"
  type        = string
}

variable "ip_address" {
  description = "The IP address to point the DNS record to"
  type        = string
}

variable "dns_ttl" {
  description = "The TTL of the DNS record"
  type        = number
  default     = 300
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
