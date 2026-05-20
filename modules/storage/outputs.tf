output "frontend_bucket_name" {
  description = "Name of the frontend S3 bucket"
  value       = aws_s3_bucket.frontend.id
}

output "frontend_bucket_arn" {
  description = "ARN of the frontend S3 bucket"
  value       = aws_s3_bucket.frontend.arn
}

output "frontend_website_endpoint" {
  description = "Website endpoint for the frontend bucket"
  value       = aws_s3_bucket_website_configuration.frontend.website_endpoint
}
