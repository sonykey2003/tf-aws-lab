
# ---------------------------------- Customisable Block Started ---------------------------------- #


# Personal Vars
variable "your-jc-username" {
  type = string
}

variable "my-aws-profile" {
  type = string
}

variable "AWS_REGION" {
  default = "ap-southeast-1"
}

variable "instance_username" {
  default = "ubuntu"
}

# Defining the VM sizes
variable "server-size" {
  type = string
  default = "t2.small" #Consider the Free tier EC2 size for cost saving - t2.micro https://aws.amazon.com/ec2/instance-types/t2/
}


# ---------------------------------- Customisable Block ended ---------------------------------- #

# DO NOT MODIFY BELOW THIS LINE!

## Getting the latest ubuntu 22.04LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
      name = "virtualization-type"
      values = ["hvm"]
  }
}

## API for attaining public IP
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

