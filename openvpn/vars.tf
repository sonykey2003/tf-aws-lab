
#ubuntu 20.04LTS for supporting openvpn
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

variable "jc-connect-key" {
  type = string
  
}

#auto gen your public ip
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

variable "AWS_REGION" {
  default = "ap-southeast-1"
}


# AWS Vars
variable "your-jc-username" {
  type = string
}

variable "my-aws-profile" {
  type = string
  default = "shawn-sedemo-admin"
}


variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}