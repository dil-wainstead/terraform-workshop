########################
# 𝖴𝖲𝖤𝖲 𝖣𝖤𝖥𝖠𝖴𝖫𝖳 𝖵𝖯𝖢 !!!
########################

variable "port" {
  description = "This is the port number we use"
  type        = number
  default     = 443
}
data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "sec_ssh" {
  # you can have as many ingress/egress blocks as you want
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "sec_ssh"
    Terraform = true
  }
}

resource "aws_security_group" "sec_http" {
  # you can have as many ingress/egress blocks as you want
  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }
  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "sec_http"
    Terraform = true
  }
}

resource "aws_instance" "sw_exercise_0200" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.sec_http.id,
    aws_security_group.sec_ssh.id
  ]

  tags = {
    Name      = "sw_exercise_0200"
    Terraform = true
    Ooga      = "booga"
  }
}

output "example-ip" {
  value       = aws_instance.sw_exercise_0200.public_ip
  description = "The public IP address of our demo server"
}

output "ami_id" {
  value       = data.aws_ami.latest_ubuntu.id
  description = "The image ID we interrogated for the Ubuntu AMI"
}
# TODO
# Introduce another security group (aws_security_group)
# with the following constraints:
# Resource name — sec_http
# vpc_id should be terraform_vpc's id
#
# TWO ingress rules
#   1. from/to 8443 using tcp from CIDR blocks 192.168.0.0/16
#   2.  from/to 443 using tcp from CIDR blocks 192.168.0.0/16
#
# ONE egress
#   1. from/to 0 using tcp to 0.0.0.0/0
#
# Be sure to tag it with a "name" and "Terraform" to true


# TODO
# Introduce a EC2 instance (aws_instance) with the following constraints:
# Resource identifier - exercise_0020
#
# ami = ami-085925f297f89fce1
# instance type = t2.micro
# VPC Security groups (vpc_security_group_ids) should
# 1. Be an array
# 2. Reference sec_http and sec_ssh
#
# Be sure to tag it with:
# - "Name" to "exercise_0020"
# - "Terraform" to true

