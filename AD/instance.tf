provider "aws" {

  profile = "shawn-sedemo-admin"
}

resource "aws_instance" "dc01" {

  # DC specs
  ami                    = var.amis[var.AWS_REGION]
  user_data_replace_on_change = true
  associate_public_ip_address = true
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.key_pair.key_name
  get_password_data      = true
  vpc_security_group_ids = [aws_security_group.allow-rdp.id,aws_security_group.allow-internal-all.id]
  subnet_id = aws_subnet.adlab-subnet.id
  tags = {
    Name = "win2022-dc01"
  }

  connection {
    host     = coalesce(self.public_ip, self.private_ip)
    type     = "winrm"
    timeout  = "5m"
    https    = true
    port     = 5986
    use_ntlm = true
    insecure = true
    user     = "Administrator"
    password = "${var.admin_pw}"
  }

  user_data = "${data.cloudinit_config.ad.rendered}"
}

resource "aws_instance" "c01" {
  # Can provision as many client as we want
  count = 1

  # Client specs
  ami                    = var.amis[var.AWS_REGION]
  user_data_replace_on_change = true
  associate_public_ip_address = true
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.key_pair.key_name
  get_password_data      = true
  vpc_security_group_ids = [aws_security_group.allow-rdp.id,aws_security_group.allow-internal-all.id]
  subnet_id = aws_subnet.adlab-subnet.id
  tags = {
    Name = "win2022-client01"
  }

  connection {
    host     = coalesce(self.public_ip, self.private_ip)
    type     = "winrm"
    timeout  = "5m"
    https    = true
    port     = 5986
    use_ntlm = true
    insecure = true
    user     = "Administrator"
    password = "${var.admin_pw}"
  }

  user_data = "${data.cloudinit_config.client.rendered}"
}


output "Administrator_Username" {
  value = "Administrator"
  
}
output "Administrator_Password" {
  value = nonsensitive("${var.admin_pw}")
  
}


output "dc01_ip_info" {
  value = ["${aws_instance.dc01.*.public_ip}","${aws_instance.dc01.*.private_ip}"]
}

output "dc01_dns_info" {
  value = ["${aws_instance.dc01.*.public_dns}","${aws_instance.dc01.*.private_dns}"]
}

output "note" {
  value = "Please give it 5~10 min before RDP-ing as the AD script is busy doing its job, go grab a coffee! :-) "
}

output "c01_ip_info" {
  value = ["${aws_instance.c01.*.public_ip}","${aws_instance.c01.*.private_ip}"]
}

output "c01_dns_info" {
  value = ["${aws_instance.c01.*.public_dns}","${aws_instance.c01.*.private_dns}"]
}

provider "aws" {

  profile = "shawn-sedemo-admin"
}

resource "aws_instance" "dc01" {

  # DC specs
  ami                    = var.amis[var.AWS_REGION]
  user_data_replace_on_change = true
  associate_public_ip_address = true
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.key_pair.key_name
  get_password_data      = true
  vpc_security_group_ids = [aws_security_group.allow-rdp.id,aws_security_group.allow-internal-all.id]
  subnet_id = aws_subnet.adlab-subnet.id
  tags = {
    Name = "win2022-dc01"
  }

  connection {
    host     = coalesce(self.public_ip, self.private_ip)
    type     = "winrm"
    timeout  = "5m"
    https    = true
    port     = 5986
    use_ntlm = true
    insecure = true
    user     = "Administrator"
    password = "${var.admin_pw}"
  }

  user_data = "${data.cloudinit_config.ad.rendered}"
}

resource "aws_instance" "c01" {
  # Can provision as many client as we want
  count = 1

  # Client specs
  ami                    = var.amis[var.AWS_REGION]
  user_data_replace_on_change = true
  associate_public_ip_address = true
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.key_pair.key_name
  get_password_data      = true
  vpc_security_group_ids = [aws_security_group.allow-rdp.id,aws_security_group.allow-internal-all.id]
  subnet_id = aws_subnet.adlab-subnet.id
  tags = {
    Name = "win2022-client01"
  }

  connection {
    host     = coalesce(self.public_ip, self.private_ip)
    type     = "winrm"
    timeout  = "5m"
    https    = true
    port     = 5986
    use_ntlm = true
    insecure = true
    user     = "Administrator"
    password = "${var.admin_pw}"
  }

  user_data = "${data.cloudinit_config.client.rendered}"
}


output "Administrator_Username" {
  value = "Administrator"
  
}
output "Administrator_Password" {
  value = nonsensitive("${var.admin_pw}")
  
}


output "dc01_ip_info" {
  value = ["${aws_instance.dc01.*.public_ip}","${aws_instance.dc01.*.private_ip}"]
}

output "dc01_dns_info" {
  value = ["${aws_instance.dc01.*.public_dns}","${aws_instance.dc01.*.private_dns}"]
}

output "note" {
  value = "Please give it 5~10 min before RDP-ing as the AD script is busy doing its job, go grab a coffee! :-) "
}

output "c01_ip_info" {
  value = ["${aws_instance.c01.*.public_ip}","${aws_instance.c01.*.private_ip}"]
}

output "c01_dns_info" {
  value = ["${aws_instance.c01.*.public_dns}","${aws_instance.c01.*.private_dns}"]
}

provider "aws" {

  profile = "shawn-sedemo-admin"
}

resource "aws_instance" "dc01" {

  # DC specs
  ami                    = var.amis[var.AWS_REGION]
  user_data_replace_on_change = true
  associate_public_ip_address = true
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.key_pair.key_name
  get_password_data      = true
  vpc_security_group_ids = [aws_security_group.allow-rdp.id,aws_security_group.allow-internal-all.id]
  subnet_id = aws_subnet.adlab-subnet.id
  tags = {
    Name = "win2022-dc01"
  }

  connection {
    host     = coalesce(self.public_ip, self.private_ip)
    type     = "winrm"
    timeout  = "5m"
    https    = true
    port     = 5986
    use_ntlm = true
    insecure = true
    user     = "Administrator"
    password = "${var.admin_pw}"
  }

  user_data = "${data.cloudinit_config.ad.rendered}"
}

resource "aws_instance" "c01" {
  # Can provision as many client as we want
  count = 1

  # Client specs
  ami                    = var.amis[var.AWS_REGION]
  user_data_replace_on_change = true
  associate_public_ip_address = true
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.key_pair.key_name
  get_password_data      = true
  vpc_security_group_ids = [aws_security_group.allow-rdp.id,aws_security_group.allow-internal-all.id]
  subnet_id = aws_subnet.adlab-subnet.id
  tags = {
    Name = "win2022-client01"
  }

  connection {
    host     = coalesce(self.public_ip, self.private_ip)
    type     = "winrm"
    timeout  = "5m"
    https    = true
    port     = 5986
    use_ntlm = true
    insecure = true
    user     = "Administrator"
    password = "${var.admin_pw}"
  }

  user_data = "${data.cloudinit_config.client.rendered}"
}


output "Administrator_Username" {
  value = "Administrator"
  
}
output "Administrator_Password" {
  value = nonsensitive("${var.admin_pw}")
  
}


output "dc01_ip_info" {
  value = ["${aws_instance.dc01.*.public_ip}","${aws_instance.dc01.*.private_ip}"]
}

output "dc01_dns_info" {
  value = ["${aws_instance.dc01.*.public_dns}","${aws_instance.dc01.*.private_dns}"]
}

output "note" {
  value = "Please give it 5~10 min before RDP-ing as the AD script is busy doing its job, go grab a coffee! :-) "
}

output "c01_ip_info" {
  value = ["${aws_instance.c01.*.public_ip}","${aws_instance.c01.*.private_ip}"]
}

output "c01_dns_info" {
  value = ["${aws_instance.c01.*.public_dns}","${aws_instance.c01.*.private_dns}"]
}

