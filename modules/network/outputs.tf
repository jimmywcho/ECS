output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of private subnets for ECS"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of public subnets for ALB"
  value       = module.vpc.public_subnets
}