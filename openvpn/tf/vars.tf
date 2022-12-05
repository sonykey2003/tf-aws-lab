
#ubuntu 20.04LTS for supporting openvpn
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "image-id"
    values = ["ami-0750a20e9959e44ff"]
  }
}

#auto gen your public ip
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

variable "AWS_REGION" {
  default = "ap-southeast-1"
}

/*
variable "PATH_TO_PRIVATE_KEY" {
   default = "/Users/ssong/.ssh/id_rsa"
}


variable "PATH_TO_PUBLIC_KEY" {
  default = "/Users/ssong/.ssh/id_rsa.pub"
}
*/

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}