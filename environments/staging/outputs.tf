output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.networking.vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.networking.private_subnet_ids
}

output "alb_sg_id" {
  description = "ALB security group ID"
  value       = module.security.alb_sg_id
}

output "ec2_sg_id" {
  description = "EC2 security group ID"
  value       = module.security.ec2_sg_id
}

output "rds_sg_id" {
  description = "RDS security group ID"
  value       = module.security.rds_sg_id
}

