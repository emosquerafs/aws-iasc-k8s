# Route53 Module for DNS Records using AWS Route53 module

# Get data about the hosted zone
data "aws_route53_zone" "selected" {
  name         = var.hosted_zone_name
  private_zone = var.private_zone
}

# Create a DNS record for the bastion host using the Route53 records module
module "route53_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "5.0.0"

  zone_id = data.aws_route53_zone.selected.zone_id

  records = [
    {
      name    = var.dns_record_name
      type    = "A"
      ttl     = var.dns_ttl
      records = [var.ip_address]
    }
  ]
}
