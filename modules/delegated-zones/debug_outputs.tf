output "debug_parent_zone" {
  description = "The parent zone data"
  value       = length(var.environments) > 0 ? data.aws_route53_zone.parent[0] : null
}

output "debug_delegated_zone_ids" {
  description = "The delegated zone IDs"
  value       = module.delegated_zones.route53_zone_zone_id
}

output "debug_zone_id_keys" {
  description = "The keys in the zone_id map"
  value       = keys(module.delegated_zones.route53_zone_zone_id)
}

output "debug_delegated_nameservers" {
  description = "The delegated zone nameservers"
  value       = module.delegated_zones.route53_zone_name_servers
}

output "debug_nameserver_keys" {
  description = "The keys in the nameservers map"
  value       = keys(module.delegated_zones.route53_zone_name_servers)
}

output "debug_environments" {
  description = "The environments variable"
  value       = var.environments
}

output "debug_delegation_records" {
  description = "The delegation records that would be created"
  value       = length(var.environments) > 0 ? [
    for key, zone_info in module.delegated_zones.route53_zone_zone_id : {
      name    = replace(key, ".${var.root_domain}", "")
      type    = "NS" 
      ttl     = var.delegation_ttl
      full_key = key
      records = module.delegated_zones.route53_zone_name_servers[key]
    }
  ] : []
}
