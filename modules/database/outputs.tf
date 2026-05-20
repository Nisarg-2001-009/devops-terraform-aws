output "db_endpoint" {
  description = "RDS endpoint — stubbed for LocalStack Community (RDS requires Pro)"
  value       = "localhost:5432"
}

output "db_name" {
  description = "Database name"
  value       = "financedb"
}

output "db_username" {
  description = "Database username"
  value       = "financeuser"
}

output "db_instance_id" {
  description = "RDS instance ID — stubbed for LocalStack Community"
  value       = "localstack-stub"
}
