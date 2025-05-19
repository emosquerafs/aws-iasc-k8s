output "fqdn" {
  description = "The fully qualified domain name of the record"
  value       = "${var.dns_record_name}.${var.hosted_zone_name}"
}

output "record_name" {
  description = "The name of the record"
  value       = var.dns_record_name
}

output "zone_id" {
  description = "The ID of the hosted zone"
  value       = data.aws_route53_zone.selected.zone_id
}

output "zone_name" {
  description = "The name of the hosted zone"
  value       = data.aws_route53_zone.selected.name
}
