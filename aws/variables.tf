variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# Create a EC2 Instance (Ubuntu 22.04)
variable "ami" {
    type = string
    default = "ami-08c40ec9ead489470"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

