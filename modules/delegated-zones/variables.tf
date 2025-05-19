variable "root_domain" {
  description = "The root domain name (e.g., singularit.co)"
  type        = string
}

variable "environments" {
  description = "List of environments to create delegated zones for (e.g., dev, stg, prod)"
  type        = list(string)
  default     = ["dev", "stg", "prod"]
}

variable "delegation_ttl" {
  description = "TTL for NS records"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Tags to apply to created resources"
  type        = map(string)
  default     = {}
}

variable "service_records" {
  description = "List of service records to create in delegated zones"
  type = list(object({
    env       = string
    name      = string
    type      = string
    ttl       = number
    addresses = list(string)
  }))
  default = []
  
  # Example:
  # service_records = [
  #   {
  #     env       = "dev"
  #     name      = "api"
  #     type      = "A"
  #     ttl       = 300
  #     addresses = ["10.0.1.123"]
  #   }
  # ]
}
