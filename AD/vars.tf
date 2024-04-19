
# AWS Vars
variable "your-jc-username" {
  type = string
}

variable "my-aws-profile" {
  type = string
}

variable "AWS_REGION" {
  default = "ap-southeast-1"
}


# Windows Server AMI
data "aws_ami" "win2022" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
  filter {
      name = "virtualization-type"
      values = ["hvm"]
  }
}


# Windows Server Instances
variable "ad-lab-instances" {
  type = map(object({
    role          = string
  }))
  default = {
    
    instances1 = {
      role = "DC"
    }
    instances2 = {
      role = "member"
    }
    instances3 = {
      role = "client"
    }
  }
}

variable "ad-lab-client-ami" {
  type = string
  default = "ami-04f734550d5bf8483"
}

# API for attaining public IP
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
  #request_body = "request body"
}

# Networking Vars
