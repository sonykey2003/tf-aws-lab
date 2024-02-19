## Use Case - A Disposable AD Lab
For those who wanted to spin up an AD env and test the lights out. 
i.e. Migrating from AD to JumpCloud via [ADMU](https://github.com/TheJumpCloud/jumpcloud-ADMU) utility, JumpCloud AD integration.

### What It Does

* Create an environment with at least 1 domain controller and 1 client with `Windows Server 2022` (public AMI).
* Auto detects and whitelists your public IP to be allowed for `RDP` & `WinRM`.
* Auto provision of ADDS, AD admin/users and OUs via `prep-ad.ps1` script (featured AWS `user_data`). 
* The secrets defined as variables will have exposures in `user-data` (in the instance setting) by design, so pls limit the scope of this project for **testing ONLY**, and remember to run `terraform destroy` once you are done. 

### Getting Started
* Fill in the desired passwords, user names and the domain name in `ad_vars.tf`.
* It will create a new VPC and use `10.10.0.0/16` CIDR, make sure it has no conflict in your existing infra. 
* DO NOT expose `ad_vars.tf` and your tf state file in any occasion, these files contain passwords and secrets. 
* (Optional) Modify, add or remove the OUs to anything you like, in `prep-ad.ps1`, line 63:
```pwsh
$newOUs = "CS_Dept","SE_Dept","FIN_Dept"
```
* Fire it UP!
* Note: You might need to refresh your SSO token every once in a while by running this:
 `aws sso login --profile your-sso-profile`.
```hcl
Terraform plan -var your-jc-username=$USER
Terraform apply -var your-jc-username=$USER
```
* Instances' IPs and login info will be presented as output, like:
```json
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
