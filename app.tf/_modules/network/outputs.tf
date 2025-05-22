output "vpc_id" {
  value = module.vpc.vpc_id
}
output "vpc_db_subnet_group_id" {
  value = module.vpc.database_subnet_group
}
output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}
output "vpc_public_subnet_ids" {
  value = var.public_subnet_ids
}

output "vpc_private_subnet_ids" {
  value = var.private_subnet_ids
}

output "intra_subnet_ids" {
  value = var.intra_subnet_ids
}



