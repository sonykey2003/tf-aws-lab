provider "aws" {
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  region     = var.AWS_REGION
}


/*
resource "aws_key_pair" "mykeypair" {
  key_name   = "shawn_keypair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}
*/

resource "aws_instance" "openvpn" {
  ami           = data.aws_ami.ubuntu.id# last parameter is the default value
  instance_type = "t3.small"
  key_name      = aws_key_pair.key_pair.key_name

   tags = {
    Name = "OpenVpn_Srv"
  }

  vpc_security_group_ids = [aws_security_group.allow-ssh.id,aws_security_group.allow-openvpn.id]

  provisioner "file" {
    source      = "./openvpn.sh"
    destination = "/tmp/openvpn.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/openvpn.sh",
      "sudo sed -i -e 's/\r$//' /tmp/openvpn.sh", # Remove the spurious CR characters.
      "sudo /tmp/openvpn.sh",
    ]
  }
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file("./linux-key-pair.pem")
  }

}

output "openvpn_ip_info" {
  value = ["${aws_instance.openvpn.*.public_ip}","${aws_instance.openvpn.*.private_ip}"]
}

output "openvpn_dns_info" {
  value = ["${aws_instance.openvpn.*.public_dns}","${aws_instance.openvpn.*.private_dns}"]
}
