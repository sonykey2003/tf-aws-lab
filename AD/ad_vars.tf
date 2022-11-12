# AD related secret
variable "admin_pw" {
  default = ""
  type      = string
  sensitive = true
}

variable "ad_pw" {
  default = ""
  type      = string
  sensitive = true
}

variable "domain_name" {
  default = ""
  type      = string
  sensitive = true
}

# Creating a domain / enterprise admin
variable "sa_name" {
  default = ""
  type      = string
  sensitive = true
}

variable "sa_pw" {
  default = ""
  type      = string
  sensitive = true
}

# Creating a domain user
variable "domain_username" {
  default = ""
  type      = string
  sensitive = true
}

variable "domain_userPw" {
  default = ""
  type      = string
  sensitive = true
}