output "key_pair_names" {
  description = "Map of key names to key pair names in AWS"
  value       = { for k, v in aws_key_pair.this : k => v.key_name }
}

output "key_pair_ids" {
  description = "Map of key names to key pair IDs in AWS"
  value       = { for k, v in aws_key_pair.this : k => v.id }
}

output "all_key_pairs" {
  description = "Map containing all key pair resources"
  value       = aws_key_pair.this
}

output "primary_key_name" {
  description = "Name of the primary key pair (first in the list)"
  value       = length(keys(aws_key_pair.this)) > 0 ? aws_key_pair.this[keys(aws_key_pair.this)[0]].key_name : null
}
