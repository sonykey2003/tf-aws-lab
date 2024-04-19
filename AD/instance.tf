# AWS Auth - Using SSO profile
provider "aws" {

  profile = var.my-aws-profile
}


# Building the instances
resource "aws_instance" "ad-lab" {
  for_each = var.ad-lab-instances
  ami = each.value.role == "client" ? var.ad-lab-client-ami:data.aws_ami.win2022.id
  instance_type = "t2.medium"
  user_data_replace_on_change = true
  associate_public_ip_address = true
  key_name               = aws_key_pair.key_pair.key_name
  get_password_data      = false
  vpc_security_group_ids = [aws_security_group.allow-rdp.id,aws_security_group.allow-internal-all.id]
  subnet_id = aws_subnet.adlab-subnet.id
  tags = {
    Name = each.value.role == "client" ? "win10-${each.value.role}-${var.your-jc-username}":"winSRV2022-${each.value.role}-${var.your-jc-username}"
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
    password = var.admin_pw
  }
  user_data = each.value.role == "DC" ? data.cloudinit_config.ad.rendered:data.cloudinit_config.client.rendered
}

# Orchestrated Outputs
output "DC_Administrator_Username" {
  value = "Administrator"
  
}

output "DC_Administrator_Password" {
  value = nonsensitive(var.admin_pw)
  
}

output "Client_Cred" {
  value = "Please refer to the PWM item '(AWS) Win10 Instance' in 'SE Demo Environment' folder."
}

output "public_ip_info" {
  value = [for instance in aws_instance.ad-lab: "${instance.tags.Name}:${instance.public_ip}"]
}

output "public_dns_info" {
  value = [for instance in aws_instance.ad-lab: "${instance.tags.Name}:${instance.public_dns}"]
}


output "private_ip_info" {
  value = [for instance in aws_instance.ad-lab: "${instance.tags.Name}:${instance.private_ip}"]
}

output "note" {
  value = "Please give it 5~10 min before RDP-ing as the AD script is busy doing its job, go grab a coffee! :-) "
}





