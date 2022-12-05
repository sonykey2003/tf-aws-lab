# Shawn's Terraform Playground - AWS
A Place to dump my creation of use cases :-)

## Prerequisites
* Installed [Terraform](https://developer.hashicorp.com/terraform/downloads) and clone this repo.
* Input your AWS access/secret keys in `secret_vars.tf` - see the sample in `exampleSecret_vars.tf`.
* (Optional) Exempt the file to be uploaded to any repo by adding this file name in `.gitignore`.
* (Optional) Fill in the info in `stateconfig.tf` if you want to escrow your [Terraform State]

## Use Case 01 - A Portable AD Environment
For those who wanted to spin up an AD env and test the lights out. 
i.e. Migrating from AD to JumpCloud via [ADMU](https://github.com/TheJumpCloud/jumpcloud-ADMU) utility. 

### What It Does

* Create an environment with at least 1 domain controller and 1 client with `Windows Server 2019` (public AMI).
* Auto detects and whitelists your public IP to be allowed for `RDP` & `WinRM`.
* Auto provision of ADDS, AD admin/users and OUs via `prep-ad.ps1` script (featured AWS `user_data`). 
* The secrets defined as variables will have exposures in `user-data` (in the instance setting) by design, so pls limit the scope of this project for **testing ONLY**, and remember to run `terraform destroy` once you are done. 

### Getting Started
* Fill in the desired passwords, user names and the domain name in `ad_vars.tf`.
* Choose and fill in the CIDR block of your designated subnet in `networking.tf`, "allow-internal-all" section -> `ingress` block. 
* (Optional) Exempt `ad_vars.tf`in `.gitignore` to limit the exposure of secrets. 
* (https://developer.hashicorp.com/terraform/language/settings/backends/configuration) to S3. Or remove this file. 
* (Optional) Modify, add or remove the OUs to anything you like, in `prep-ad.ps1`, line 63:
```pwsh
$newOUs = "CS_Dept","SE_Dept","FIN_Dept"
```
* Fire it UP!
```zsh
Terraform plan
Terraform apply
```
* Instances' IPs and login info will be presented as output, like:
```json
Outputs:

Administrator_Password = ""
Administrator_Username = "Administrator"
c01_dns_info = [
  [
    "ip-<public-ip>.ap-southeast-1.compute.amazonaws.com",
  ],
  [
    "ip-<private-ip>.ap-southeast-1.compute.internal",
  ],
]
c01_ip_info = [
  [
    "<public-ip>",
  ],
  [
    "<private-ip>",
  ],
]
dc01_dns_info = [
  [
    "<public-ip>.ap-southeast-1.compute.amazonaws.com",
  ],
  [
    "<private-ip>.ap-southeast-1.compute.internal",
  ],
]
dc01_ip_info = [
  [
    "<public-ip>",
  ],
  [
    "<private-ip>",
  ],
]
note = "Please give it 5~10 min before RDP-ing as the AD script is busy doing its job, go grab a coffee! :-) "
```

## Use Case 02 - OpenVPN Server Template
You can integrate with an IdP like JumpCloud via various protocols:

* RADIUS
* LDAP
* SAML 2.0


### What It Does
* Create an EC2 instance with `t3.small` spec.
* Auto provision OpenVPN installation from the [official source](https://openvpn.net/vpn-software-packages/ubuntu/). 


### Getting Started
* You can choose to build the OpenVPN server on AWS or locally-hosted (via [Vagrant](https://developer.hashicorp.com/vagrant/downloads)).
* Your public IP will be whitelisted by default as configured in `securitygroup.tf`.
* Refer to the steps [here](https://sonykey2003.medium.com/integrate-openvpn-with-jumpclouds-radius-as-a-service-b0cac64578a9) for JC RADIUS integration. 