variable "ami_id" {
  description = "ami_id"
  type = string
}

variable "instance_type" {
  description = "instance_type"
  type= string
  default = "t3.micro"
  }

  variable "project_name" {
    default = "terraform_ALB"
  }
  variable "region" {
    default = "ap-south-1"
  }