
#a list of win10 AMIs
variable "amis" {
  type = map(any)
  default = {
    "ap-southeast-1" = "ami-0adcf082d85f6a445"
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
