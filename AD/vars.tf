# ---------------------------------- Customisable Block Started ---------------------------------- #

# Personal Vars
variable "your-jc-username" {
  type = string
}

variable "my-aws-profile" {
  type = string
}

# Your default AWS region
variable "AWS_REGION" {
  default = "eu-west-2" 
}


# Defining the VM sizes
variable "client-size" {
  type = string
  default = "t2.medium" #Consider the Free tier EC2 size for cost saving - t2.micro https://aws.amazon.com/ec2/instance-types/t2/
}

variable "server-size" {
  type = string
  default = "t2.medium" #Consider the Free tier EC2 size for cost saving - t2.micro https://aws.amazon.com/ec2/instance-types/t2/
}

# ---------------------------------- Customisable Block ended ---------------------------------- #


# DO NOT MODIFY BELOW THIS LINE!

## Windows Server 2022 AMI - Public AMIs
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

## Windows Client (10 pro) AMIs - Private AMIs
variable "ad-lab-client-ami" {
  type = map(string)
  default = {
    "ap-southeast-1" = "ami-04f734550d5bf8483" #Singapore
    "ap-south-1" = "ami-02c73ac45d91a3112" #Mumbai
    "eu-west-2" = "ami-03a65b215724e0c3c" #London
    "us-east-1" = "ami-04928784f495b5ead" #N.Virginia 

  }
}


## Windows Server Instances & Roles
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

## API for attaining public IP
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

