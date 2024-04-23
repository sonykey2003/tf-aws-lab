# ---------------------------------- Customisable Block Started ---------------------------------- #

# Personal Vars
variable "your-jc-username" {
  type = string
}

variable "my-aws-profile" {
  type = string
}

variable "how-many-servers" {
  type = number
}

# Your default AWS region
variable "AWS_REGION" {
  default = "ap-southeast-1"
}

# Defining the VM sizes
variable "server-size" {
  type = string
  default = "t3.small" #Consider the Free tier EC2 size for cost saving - t2.micro https://aws.amazon.com/ec2/instance-types/t2/
}


variable "linux-distro" {
  type = string
  default = "ubuntu" # Pick a distro from: ubuntu, rhel, or amzn2
}

# ---------------------------------- Customisable Block ended ---------------------------------- #

# DO NOT MODIFY BELOW THIS LINE!

## Getting the latest Linux AMIs from AWS marketplace
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

data "aws_ami" "rhel" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["RHEL-9.*"]
  }
  filter {
      name = "virtualization-type"
      values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "amzn2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-ecs-hvm-2.*"]
  }
  filter {
      name = "virtualization-type"
      values = ["hvm"]
  }
  
}

locals {
  linux-ami-id = {
    "ubuntu" = data.aws_ami.ubuntu.id
    "rhel"   = data.aws_ami.rhel.id
    "amzn2" = data.aws_ami.amzn2.id
    # More can be added here
  }
}


# Default Instance username
variable "instance_username" {
  type = map(string)
  default = {
    "ubuntu" = "ubuntu"
    "rhel" = "ec2-user"
    "amzn2" = "ec2-user"
  }
}


## API for attaining public IP
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
