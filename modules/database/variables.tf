variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of private subnets for RDS"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "Security group ID for RDS"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "financedb"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "financeuser"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
  default     = "financepass123"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}
