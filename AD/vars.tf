
#a list of win10 AMIs
variable "amis" {
  type = map(any)
  default = {
    "ap-southeast-1" = "ami-04fd9ca55428190ad"
    "ap-southeast-2" = "ami-0aea49ff8f0efa479"
  }
}

#auto gen your public ip
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
  #request_body = "request body"
}

variable "AWS_REGION" {
  default = "ap-southeast-1"
}
