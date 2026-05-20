output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.backend.id
}

output "ec2_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.backend.private_ip
}

output "alb_dns_name" {
  description = "ALB DNS — stubbed for LocalStack Community (ELBv2 requires Pro)"
  value       = "localstack-stub-alb.us-east-1.elb.amazonaws.com"
}

output "alb_arn" {
  description = "ALB ARN — stubbed for LocalStack Community"
  value       = "arn:aws:elasticloadbalancing:us-east-1:000000000000:loadbalancer/app/stub/stub"
}

output "target_group_arn" {
  description = "Target group ARN — stubbed for LocalStack Community"
  value       = "arn:aws:elasticloadbalancing:us-east-1:000000000000:targetgroup/stub/stub"
}
