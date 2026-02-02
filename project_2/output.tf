output "public_ip" {
  value =aws_instance.web[*].subnet_id
}

output "web_url" {
  value =[for i in aws_instance.web : "http://${i.subnet_id}"]
}

output "alb_dns" {
  value = aws_lb.alb.dns_name
}
