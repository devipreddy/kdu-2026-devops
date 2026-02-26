output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  value = module.vpc.private_app_subnet_ids
}

output "db_subnet_ids" {
  value = module.vpc.db_subnet_ids
}

output "alb_sg_id" {
  value = module.security.alb_sg_id
}

output "app_sg_id" {
  value = module.security.app_sg_id
}

output "db_sg_id" {
  value = module.security.db_sg_id
}

output "bastion_sg_id" {
  value = module.security.bastion_sg_id
}

output "bastion_public_ip" {
  value = module.compute.bastion_public_ip
}

output "asg_name" {
  value = module.compute.asg_name
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}