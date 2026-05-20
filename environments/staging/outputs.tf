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

output "frontend_bucket_name" {
  description = "Frontend S3 bucket name"
  value       = module.storage.frontend_bucket_name
}

output "frontend_website_endpoint" {
  description = "Frontend S3 website endpoint"
  value       = module.storage.frontend_website_endpoint
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name — access the API here"
  value       = module.compute.alb_dns_name
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = module.compute.ec2_instance_id
}

output "ec2_private_ip" {
  description = "EC2 private IP address"
  value       = module.compute.ec2_private_ip
}

