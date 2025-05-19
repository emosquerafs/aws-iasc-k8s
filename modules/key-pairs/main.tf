/* 
  Key Pairs Module
  This module manages AWS key pairs for SSH access to EC2 instances
*/

# Create key pairs from the provided public key map
resource "aws_key_pair" "this" {
  for_each = var.public_keys

  key_name   = "${var.name_prefix}-${each.key}"
  public_key = each.value
  
  tags = merge(
    var.tags,
    {
      Name        = "${var.name_prefix}-${each.key}"
      Description = "Key pair for ${each.key}"
    }
  )
}
