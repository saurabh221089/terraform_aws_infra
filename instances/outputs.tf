output "LoadBalancer" {
  description = "URL of load balancer"
  value       = aws_elb.webapp_load_balancer.dns_name
}

output "Image_ID" {
  description = "Image ID of AMI"
  value       = data.aws_ami.launch_config_ami.id
}