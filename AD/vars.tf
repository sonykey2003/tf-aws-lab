
# AWS Vars
variable "your-jc-username" {
  type = string
}

variable "my-aws-profile" {
  type = string
  default = "shawn-sedemo-admin"
}

variable "AWS_REGION" {
  default = "ap-southeast-1"
}


# Windows Server Instances
variable "ad-lab-instances" {
  type = map(object({
    ami           = string
    role          = string
  }))
  default = {
    
    instances1 = {
      role = "DC"
      ami = "ami-0adcf082d85f6a445" # Win Srv 2022,SG,public
    }
    instances2 = {
      role = "member"
      ami = "ami-0adcf082d85f6a445" # Win Srv 2022,SG,public
    }
    instances3 = {
      role = "client"
      ami = "ami-04f734550d5bf8483" # Win 10 pro,SG,prviate
    }
  }
}

# Linux Server AMIs
variable "linux-amis" {
  type = map(any)
  default = {
    "ap-southeast-1" = "ami-0adcf082d85f6a445"
    "ap-southeast-2" = "ami-0aea49ff8f0efa479"
  }
}

# API for attaining public IP
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
  #request_body = "request body"
}

# Networking Vars
