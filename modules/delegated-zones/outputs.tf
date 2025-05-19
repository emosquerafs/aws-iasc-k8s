output "zone_ids" {
  description = "Map of environment names to their hosted zone IDs"
  value       = module.delegated_zones.route53_zone_zone_id
}

output "name_servers" {
  description = "Map of environment names to their name servers"
  value       = module.delegated_zones.route53_zone_name_servers
}

output "zone_arns" {
  description = "Map of environment names to their hosted zone ARNs"
  value       = module.delegated_zones.route53_zone_zone_arn
}

output "fqdns" {
  description = "Map of environment names to their fully qualified domain names"
  value       = { for env in var.environments : env => "${env}.${var.root_domain}" }
}

output "delegation_record_fqdns" {
  description = "The FQDNs of the delegation NS records"
  value       = module.delegation_records.route53_record_fqdn
}

output "service_record_fqdns" {
  description = "Map of service record FQDNs"
  value = length(var.service_records) > 0 ? merge([
    for key, record in module.service_records : {
      for name, fqdn in record.route53_record_fqdn : key => fqdn
    }
  ]...) : {}
}
