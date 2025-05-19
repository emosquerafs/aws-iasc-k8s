/*
 * Delegated Zones Module
 * ======================
 *
 * This module creates delegated zones for environment-specific DNS management:
 * - Creates separate Route53 hosted zones for each environment (dev.domain.com, stg.domain.com, etc.)
 * - Sets up proper NS record delegation in the parent zone
 * - Optionally creates service records in each environment
 *
 * Uses official AWS modules:
 * - terraform-aws-modules/route53/aws//modules/zones
 * - terraform-aws-modules/route53/aws//modules/records
 */

# Get the parent hosted zone data
data "aws_route53_zone" "parent" {
  count = length(var.environments) > 0 ? 1 : 0
  name = var.root_domain
}

# Create delegated zones for each environment using the zones module
module "delegated_zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = {
    for env in var.environments : "${env}.${var.root_domain}" => {
      comment = "Delegated zone for ${env} environment"
      tags = merge(
        var.tags,
        {
          Environment = env
          Name        = "${env}.${var.root_domain}"
        }
      )
    }
  }

  tags = var.tags
}

# Create NS records in the parent zone to delegate to the child zones
module "delegation_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"
  
  count = length(var.environments) > 0 ? 1 : 0
  
  zone_id = data.aws_route53_zone.parent[0].zone_id

  records = [
    for env, zone_info in module.delegated_zones.route53_zone_zone_id : {
      name    = "${env}.${var.root_domain}"
      type    = "NS"
      ttl     = var.delegation_ttl
      records = module.delegated_zones.route53_zone_name_servers[env]
    }
  ]
}

# Optionally create service records in each delegated zone
locals {
  # Pre-compute all possible service record mappings to make it more deterministic
  env_domains = { for env in var.environments : env => "${env}.${var.root_domain}" }
  
  # Create a mapping of service records with their target zones
  service_record_mappings = [
    for record in var.service_records : 
    {
      key = "${record.env}_${record.name}"
      env = record.env
      domain = lookup(local.env_domains, record.env, "")
      record_data = {
        name = record.name
        type = record.type
        ttl = record.ttl
        addresses = record.addresses
      }
    }
    if contains(var.environments, record.env)
  ]
  
  # Group them by environment for easier processing
  service_records_by_env = { 
    for env in var.environments : env => [
      for mapping in local.service_record_mappings : mapping
      if mapping.env == env
    ]
  }
}

# Create individual record resources instead of using the module
# This avoids the count/for_each dependency problem in the AWS module
resource "aws_route53_record" "service_records" {
  for_each = {
    for mapping in local.service_record_mappings : "${mapping.env}_${mapping.record_data.name}" => mapping
  }
  
  zone_id = module.delegated_zones.route53_zone_zone_id["${each.value.env}.${var.root_domain}"]
  name    = each.value.record_data.name
  type    = each.value.record_data.type
  ttl     = each.value.record_data.ttl
  records = each.value.record_data.addresses
}
