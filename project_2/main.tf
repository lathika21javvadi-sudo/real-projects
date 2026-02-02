resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name="${var.project_name}_vpc"
  }
 }

 resource "aws_subnet" "subnet" {
   cidr_block = "10.0.1.0/24"
   vpc_id= aws_vpc.vpc.id
   map_public_ip_on_launch = true
   tags = {
    name= "${var.project_name}_subnet"
   }
 }

 resource "aws_subnet" "subnet2" {
  cidr_block              = "10.0.2.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1b"

  tags = {
    name = "${var.project_name}_subnet2"
  }
}


resource "aws_internet_gateway" "ig" {
  vpc_id=aws_vpc.vpc.id
}
 resource "aws_route_table" "route_table" {
     vpc_id=aws_vpc.vpc.id

     route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig.id
     }
 }
 resource "aws_route_table_association" "rta" {
   subnet_id      = aws_subnet.subnet.id

   route_table_id = aws_route_table.route_table.id
 }

 resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.route_table.id
}

 resource "aws_security_group" "alb_sg" {
name ="alb-sg"
vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   
 }

 resource "aws_instance" "web" {
   
   count = 2
   ami = "ami-019715e0d74f695be"
   instance_type = var.instance_type
   subnet_id = aws_subnet.subnet.id


   vpc_security_group_ids = [aws_security_group.alb_sg.id]
   user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
echo "<h1>Server $(hostname) - Terraform ALB Project</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "${var.project_name}-web-${count.index}"
  }

 }
 resource "aws_lb_target_group" "tg" {
  name ="web-tg"
port =80
protocol ="HTTP"
vpc_id =aws_vpc.vpc.id   
health_check {
    path = "/"
    port = "80"
  }
 }

 resource "aws_lb_target_group_attachment" "tg_attach" {
  count            = 2
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
 }


resource "aws_lb" "alb" {
  name               = "web-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
 subnets = [
  aws_subnet.subnet.id,
  aws_subnet.subnet2.id
]

}


resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

