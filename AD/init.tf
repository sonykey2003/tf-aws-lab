data "cloudinit_config" "ad" {
  gzip = false
  base64_encode = false
  part {
    filename = "prep-ad.ps1"
    content_type = "text/x-shellscript"
    content = templatefile(
                 "${path.module}/prep-ad.ps1",
                 {
                  admin_pw = "${var.admin_pw}"
                  ad_pw = "${var.ad_pw}",
                  domain_name = "${var.domain_name}",
                  sa_name = "${var.sa_name}",
                  sa_pw = "${var.sa_pw}",
                  domain_username = "${var.domain_username}",
                  domain_userPw = "${var.domain_userPw}"    
                 }
              )
  }

  /*part {
    filename = "prep-ad.ps1"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/test.ps1",{p1 = "parameter1", p2 = "parameter2"})
  }*/
  
}

data "cloudinit_config" "client" {
  gzip = false
  base64_encode = false
  part {
    filename = "prep-client.ps1"
    content_type = "text/x-shellscript"
    content = templatefile(
                 "${path.module}/prep-client.ps1",
                 {
                  admin_pw = "${var.admin_pw}"
                 }
              )
  }

}