resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name="${project_name}_vpc"
  }
 }

 resource "aws_subnet" "subnet" {
   cidr_block = "10.0.1.0/24"
   vpc_id= aws_vpc.vpc.id
   map_public_ip_on_launch = true
   tags = {
    name= "${project_name}_subnet"
   }
 }

resource "aws_internet_gateway" "ig" {
  vpc_id=aws_vpc.vpc.id
}
 resource "aws_route_table" "route_table" {
     vpc_id=aws_vpc.vpc.id

     route {
        cidr_block = ="0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig.id
     }
 }
 resource "aws_route_table_association" "rta" {
   subnet_id = aws_subnet.subnet.id
   route_table_id = aws_route_table.route_table.id

 }

 resource "aws_security_group" "sg" {
   
 }

 resource "aws_instance" "ins_1" {
   
 }
 resource "aws_instance" "ins_2" {
   
 }