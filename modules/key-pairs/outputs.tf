output "key_pair_names" {
  description = "Map of key names to key pair names in AWS"
  value       = { for k, v in module.key_pair : k => v.key_pair_name }
}

output "key_pair_ids" {
  description = "Map of key names to key pair IDs in AWS"
  value       = { for k, v in module.key_pair : k => v.key_pair_id }
}

output "all_key_pairs" {
  description = "Map containing all key pair resources"
  value       = module.key_pair
}

output "primary_key_name" {
  description = "Name of the primary key pair (first in the list)"
  value       = length(keys(module.key_pair)) > 0 ? module.key_pair[keys(module.key_pair)[0]].key_pair_name : null
}
