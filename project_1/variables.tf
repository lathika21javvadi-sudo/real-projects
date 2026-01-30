variable "region" {
  default = "ap-south-1"
}
variable "instance-type" {
    description ="ec2_instance"
  type = string
  default = "t3.micro"
}
variable "project-name" {
  default = "terraform-webserver"
}
variable "ami_id" {
   description ="ami_id"
  type = string
  }
