# AWS Auth - Using SSO profile
provider "aws" {

  profile = var.my-aws-profile
  region = var.AWS_REGION
}

resource "aws_instance" "linuxsrv" {
  count = var.how-many-servers

  #ami           = var.linux-ami-id[var.linux-distro]
  ami = local.linux-ami-id[var.linux-distro] # Using ubuntu by default
  instance_type = var.server-size
  key_name      = aws_key_pair.key_pair.key_name

   tags = {
    Name = "linux-srv-${var.your-jc-username}-${count.index + 1}"
  }

  vpc_security_group_ids = [aws_security_group.allow-ssh.id,aws_security_group.allow-internal-all.id]
  subnet_id = aws_subnet.linux-subnet.id



  # Installing the JC agent
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname linux-srv-${var.your-jc-username}-${count.index + 1}",
      "sleep 120",
      "curl --tlsv1.2 --silent --show-error --header 'x-connect-key: ${var.jc-connect-key}' https://kickstart.jumpcloud.com/Kickstart | sudo bash"

     ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.instance_username[var.linux-distro]
    private_key = file("./linux-key-pair.pem")
  }

}

output "public_ip_info" {
  value = [for i in range(length(aws_instance.linuxsrv)) : "Server Name: ${aws_instance.linuxsrv[i].tags["Name"]}, Public IP: ${aws_instance.linuxsrv[i].public_ip}"]
}

output "public_dns_info" {
  value = [for i in range(length(aws_instance.linuxsrv)) : "Server Name: ${aws_instance.linuxsrv[i].tags["Name"]}, Public DNS: ${aws_instance.linuxsrv[i].public_dns}"]
}

output "private_ip_info" {
  value = [for i in range(length(aws_instance.linuxsrv)) : "Server Name: ${aws_instance.linuxsrv[i].tags["Name"]}, Private IP: ${aws_instance.linuxsrv[i].private_ip}"]
}
