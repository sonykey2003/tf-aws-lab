# AWS Auth - Using SSO profile
provider "aws" {

  profile = var.my-aws-profile
}

resource "aws_instance" "openvpn" {
  ami           = data.aws_ami.ubuntu.id #last parameter is the default value
  instance_type = var.server-size
  key_name      = aws_key_pair.key_pair.key_name

   tags = {
    Name = "OpenVpn-Srv-${var.your-jc-username}"
  }

  vpc_security_group_ids = [aws_security_group.allow-ssh.id,aws_security_group.allow-internal-all.id,aws_security_group.allow-openvpn.id]
  subnet_id = aws_subnet.linux-subnet.id

  provisioner "file" {
    source      = "./openvpn.sh"
    destination = "/tmp/openvpn.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/openvpn.sh",
      "sudo sed -i -e 's/\r$//' /tmp/openvpn.sh", # Remove the spurious CR characters.
      "sudo /tmp/openvpn.sh"
    ]
  }

 # Installing JC agent inline
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname OpenVpn-Srv-${var.your-jc-username}",
      "curl --tlsv1.2 --silent --show-error --header 'x-connect-key: ${var.jc-connect-key}' https://kickstart.jumpcloud.com/Kickstart | sudo bash"
    ]
  }
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.instance_username
    private_key = file("./linux-key-pair.pem")
  }

}

output "instance_ip_info" {
  value = ["${aws_instance.openvpn.*.public_ip}","${aws_instance.openvpn.*.private_ip}"]
}

output "instance_dns_info" {
  value = ["${aws_instance.openvpn.*.public_dns}","${aws_instance.openvpn.*.private_dns}"]
}

output "openvpn_login_info" {
  value = ["Login to OpenVPN admin console: https://${aws_instance.openvpn.public_ip}:943/admin","Admin credential can be found in /usr/local/openvpn_as/init.log"]
}