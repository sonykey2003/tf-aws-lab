resource "aws_security_group" "allow-ssh" {
  #vpc_id      = aws_vpc.main.id
  name        = "allow-ssh"
  description = "security group that allows ssh from my home IP and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }
  tags = {
    Name = "allow-ssh"
  }
}

resource "aws_security_group" "allow-openvpn" {
  #vpc_id      = aws_vpc.main.id
  name        = "allow-openvpn"
  description = "security group that allows openvpn ports from my home IP and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }
  ingress {
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }
  tags = {
    Name = "allow-openvpn"
  }
}