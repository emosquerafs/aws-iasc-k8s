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

  zone_id = data.aws_route53_zone.parent.zone_id

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
module "service_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"
  
  for_each = {
    for record in var.service_records : "${record.env}_${record.name}" => record
    if contains(var.environments, record.env)
  }
  
  zone_id = module.delegated_zones.route53_zone_zone_id["${each.value.env}.${var.root_domain}"]

  records = [
    {
      name    = each.value.name
      type    = each.value.type
      ttl     = each.value.ttl
      records = each.value.addresses
    }
  ]
}
