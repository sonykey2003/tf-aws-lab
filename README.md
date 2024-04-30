# A Use-case-driven AWS Server Lab

## Network Diagram

<img src="https://github.com/sonykey2003/win-auto-pilot/assets/19852184/505d522e-d88a-4c28-8871-9706609d8acd"  width=50% height=50%>


## Prerequisites
* Installed [Terraform](https://developer.hashicorp.com/terraform/downloads) and clone this repo.
* Install [AWS Cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) - recommend using the `GUI installer`.
* Create an AWS Cli SSO profile as instructed [here](https://docs.aws.amazon.com/cli/latest/userguide/sso-configure-profile-token.html#sso-configure-profile-token-auto-sso).
  * Once the profile is created, you can login to refresh the SSO token by specifying the profile like [here](https://docs.aws.amazon.com/cli/latest/userguide/sso-using-profile.html). 
* Setup [SSO for AWS IAM Identity Center](https://community.jumpcloud.com/t5/best-practices/setting-up-sso-for-aws-iam-or-aws-identity-center/m-p/2702#M123) on your JumpCloud tenant.
* Dive into respective folders for each use case, and run Terraform from there.

## Customisable Options
Before we dive into each use case below, there are a few common options you can customise in each `vars.tf`:
* Your preferred AWS region.
  * Please sepcify your region (likely tied to where you based) - look for `AWS_REGION`variable, change it accordingly. 
  * Avaliable regions: 
    * ap-southeast-1  # Singapore
    * ap-south-1  # Mumbai
    * eu-west-2 # London
    * us-east-1 # N.Virginia 
* EC2 Instance type (VM sizes).
* Your AWS CLI SSO profile name.
* Your JumpCloud username for instance tagging of ownership. 

And **DO NOT** modify the lines beyond the end of customisable block. 

## Use Case 1 - A Disposable AD Lab
For those who wanted to spin up an AD env and test the lights out. 
i.e. Migrating from AD to JumpCloud via [ADMU](https://github.com/TheJumpCloud/jumpcloud-ADMU) utility, JumpCloud AD integration.

### What It Does & Considerations
* Creating an mini AD environment with at least 1 domain controller and 1 client with `Windows Server 2022` (public AMI).
* Auto detects and whitelists your present public IP to be allowed for `RDP` & `WinRM`.
* Auto provision: ADDS feature, AD admin/users and OUs via `prep-ad.ps1` script (via AWS [`user_data`](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-add-user-data.html) ). 
* The secrets are defined as variables in `ad_vars.tf` will be exposed in `user_data` (in the instance setting) by design, so pls limit the scope of this project for **testing ONLY**, and be reminded to run `terraform destroy` once you are done. 

### Getting Started
* Rename file `example_secret_tf` to `ad_vars.tf`.
* Fill in the desired passwords, user names and the domain name in `ad_vars.tf`. 
  * **Note**: Never Ever expose this file anywhere. 
* It will create a new VPC and use `10.10.0.0/16` CIDR, subsequently a subnet `10.10.10.0/24` will be created for placing the VMs. Please make sure it has no conflict in your existing infra. 
* DO NOT expose `secret.tf` and your tf state file in any occasion, these files contain passwords and secrets. 
* (Optional) Modify, add or remove the OUs to anything you like, in `prep-ad.ps1`, line 61:
```pwsh
$newOUs = "CS_Dept","SE_Dept","FIN_Dept"
```
* Fire it UP!
**Note**: You might need to refresh your SSO token at the begining of every session:

```sh
aws sso login --profile your-sso-profile
```

```sh
Terraform plan -var your-jc-username=$USER
Terraform apply -var your-jc-username=$USER
```
* Instances' IPs and login info will be presented as output, like:
```sh
Outputs:

Administrator_Password = ""
Administrator_Username = "Administrator"

private_ip_info = [
  "winSRV2022-DC-<username>:<private-ip>",
  "winSRV2022-member-<username>:<private-ip>",
  "win10-client-<username>:<private-ip>",
]
public_dns_info = [
  "winSRV2022-DC-<username>:ec2-<public-ip>.ap-southeast-1.compute.amazonaws.com",
  "winSRV2022-member-<username>:ec2-<public-ip>.ap-southeast-1.compute.amazonaws.com",
  "win10-client-<username>:ec2-<public-ip>.ap-southeast-1.compute.amazonaws.com",
]
public_ip_info = [
  "winSRV2022-DC-<username>:<public-ip>",
  "winSRV2022-member-<username>:<public-ip>",
  "win10-client-<username>:<public-ip>",
]

note = "Please give it 5~10 min before RDP-ing as the AD script is busy doing its job, go grab a coffee! :-) "
```

## Use Case 2 - A Linux Server Farm
### Getting Started
* Rename file `example_secret_tf` to `secret.tf`.
* Fill in the desired passwords, user names and your JumpCloud [Connect Key](https://jumpcloud.com/support/understand-the-agent) in `secret.tf`. 
  * **Note**: Never Ever expose this file anywhere. 
* It will create a new VPC and use `10.10.0.0/16` CIDR, subsequently a subnet `10.10.11.0/24` will be created for placing the VMs. Please make sure it has no conflict in your existing infra. 
* DO NOT expose `secret.tf` and your tf state file in any occasion, these files contain passwords and secrets. 
* Fire it UP!
```sh
# You might need to refresh your SSO token:
aws sso login --profile your-sso-profile

# For windows
Terraform plan -var your-jc-username=$USER \
  -var my-aws-profile=your-sso-profile

Terraform apply -var your-jc-username=$USER \
  -var my-aws-profile=your-sso-profile

# For Linux - an empty .pem file needs to be present prior tf apply
touch linux-key-pair.pem && Terraform plan -var your-jc-username=$USER \
  -var my-aws-profile=your-sso-profile

Terraform apply -var your-jc-username=$USER \
  -var my-aws-profile=your-sso-profile

```
* Instances' IPs and login info will be presented as output, like:
```json
Outputs:

private_ip_info = [
  "Server Name: linux-srv-<yourUsername>-1, Private IP: <private_ip>",
  "Server Name: linux-srv-<yourUsername>-2, Private IP: <private_ip>",
]
public_dns_info = [
  "Server Name: linux-srv-<yourUsername>-1, Public DNS: ec2-public-ip.ap-southeast-1.compute.amazonaws.com",
  "Server Name: linux-srv-<yourUsername>-2, Public DNS: ec2-public-ip.ap-southeast-1.compute.amazonaws.com",
]
public_ip_info = [
  "Server Name: linux-srv-<yourUsername>-1, Public IP: <public_ip>",
  "Server Name: linux-srv-<yourUsername>-2, Public IP: <public_ip>",
]

```

## Use Case 3 - OpenVPN Server Template
You can integrate it with an IdP like JumpCloud via a protocol at your choice:
* RADIUS
* LDAP
* SAML 2.0

### What It Does & Considerations
* Create an `Ubuntu 22.04`(latest AMI) EC2 instance with `t3.small` spec. 
* Auto provision OpenVPN installation from the [official source](https://openvpn.net/vpn-software-packages/ubuntu/). 
* Install the JumpCloud agent and enroll the server to your JC tenant. 

### Getting Started
* Rename file `example_secret_tf` to `secret.tf`.
* Fill in the desired passwords, user names and your JumpCloud [Connect Key](https://jumpcloud.com/support/understand-the-agent) in `secret.tf`. 
  * **Note**: Never Ever expose this file anywhere. 
* Create an empty file `linux-key-pair.pem` at the root of the openVPN terraform folder. 
* It will create a new VPC and use `10.10.0.0/16` CIDR, subsequently a subnet `10.10.12.0/24` will be created for placing the VMs. Please make sure it has no conflict in your existing infra. 
* Your public IP will be whitelisted by default as configured in `networking.tf`.
* Fire it UP!

```sh
# You might need to refresh your SSO token:
aws sso login --profile your-sso-profile



# Plan the changes
Terraform plan \
 -var your-jc-username=$USER \
 -var jc-connect-key=<your JC Connect Key>

# Apply after the planning
touch linux-key-pair.pem && Terraform apply \
 -var your-jc-username=$USER \
 -var jc-connect-key=<your JC Connect Key> \
 -var my-aws-profile=<your sso profile>

# Change the key permission before SSH to the instance
chmod 400 linux-key-pair.pem 
```
* Instances' IPs and login info will be presented as output, like:
```json
Outputs:

openvpn_dns_info = [
  [
    "ec2-<public_IP>.ap-southeast-1.compute.amazonaws.com",
  ],
  [
    "ip-<private-IP>.ap-southeast-1.compute.internal",
  ],
]
openvpn_ip_info = [
  [
    "<public_IP>",
  ],
  [
    "<private-IP>",
  ],
]

```
* Now you can login to the WebUI to configure the OpenVPN server @
`https://ec2-<public_IP>.ap-southeast-1.compute.amazonaws.com:943`
    * Login credentials can be found on the server `/usr/local/openvpn_as/init.log`
* Integrate Radius auth with JumpCloud, refer to the steps [here](https://sonykey2003.medium.com/integrate-openvpn-with-jumpclouds-radius-as-a-service-b0cac64578a9) for JC RADIUS integration. 


