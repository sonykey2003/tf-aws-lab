## Use Case - OpenVPN Server Template
You can integrate with an IdP like JumpCloud via various protocols:

* RADIUS
* LDAP
* SAML 2.0

### What It Does
* Create an `Ubuntu 22.04`(latest AMI) EC2 instance with `t3.small` spec. 
* Auto provision OpenVPN installation from the [official source](https://openvpn.net/vpn-software-packages/ubuntu/). 
* Enroll the server to your JC tenant. 

### Getting Started
* Create an empty file `linux-key-pair.pem` at the root of the openVPN terraform folder. 
* It will create a new VPC and use `10.10.0.0/16` CIDR, subsequently a subnet `10.10.11.0/24` will be created for placing the VMs. Please make sure it has no conflict in your existing infra. 
* Your public IP will be whitelisted by default as configured in `networking.tf`.
* Fire it UP!

```hcl
# You might need to refresh your SSO token:
aws sso login --profile your-sso-profile



# Plan the changes
Terraform plan \
 -var your-jc-username=$USER \
 -var jc-connect-key=<your JC Connect Key>

# Apply after the planning
touch linux-key-pair.pem && chmod 400 linux-key-pair.pem && Terraform apply \
 -var your-jc-username=$USER \
 -var jc-connect-key=<your JC Connect Key>
```
* Instances' IPs and login info will be presented as output, like:
```json
Outputs:

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