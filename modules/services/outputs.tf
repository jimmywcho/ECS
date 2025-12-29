output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb.dns_name
}



output "ecr_repository_url" {
  value = module.ecr.repository_url
}