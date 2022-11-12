# Default VPC 
data "aws_vpc" "default" {
  default = true
} 

# Creating internal networks
resource "aws_subnet" "main" {
  vpc_id     = data.aws_vpc.default.id
  cidr_block = ""
  map_public_ip_on_launch = true
  tags = {
    Name = "ADEnv"
  }
}
# Creating security groups for internet connectivities
resource "aws_security_group" "allow-rdp" {
  name        = "allow-rdp"
  description = "security group that allows rdp from my home IP and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }
  
  ingress {
    from_port   = 5986
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }
  ingress {
    from_port   = 5985
    to_port     = 5985
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }
  tags = {
    Name = "allow-rdp/winrm"
  }

}

# Creating security groups for private subnet connectivities
resource "aws_security_group" "allow-internal-all" {
  name        = "allow-internal-all"
  description = "security group that allows all traffic from the same subnet"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["your_subnet_cidr_block"]
  }
  
 
  tags = {
    Name = "allow-internal-all"
  }

}



