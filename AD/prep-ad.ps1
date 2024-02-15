<script>
   winrm quickconfig -q & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}
   netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
</script>
<powershell>
    # Set Administrator password
    $admin = [adsi]("WinNT://./administrator, user")
    $admin.psbase.invoke("SetPassword", "${admin_pw}")

    #start AD part
    Get-WindowsFeature "Telnet-Client" | Install-WindowsFeature
    $adState = (Get-WindowsFeature -Name "AD-Domain-Services").installed
    if (!$adState) {
        Write-Host "AD installed: $adState"

        # Adding a local admin for login after reboot
        #New-LocalUser -Name localAdmin -AccountNeverExpires -Password ("local@dmin1!" | ConvertTo-SecureString -AsPlainText -Force) 
        #Add-LocalGroupMember -Group administrators -Member localadmin 


        
        # Step 1 DNS
        $nic = Get-NetIPAddress | ? {$_.PrefixOrigin -like "Dhcp"}
        Set-DnsClientServerAddress -InterfaceIndex  $nic.InterfaceIndex -ServerAddresses $nic.IPAddress
            
        # Step 2 install AD and reboot
        $adpw = "${ad_pw}"| ConvertTo-SecureString -AsPlainText -Force
        $dominame = "${domain_name}"
        $ADfunclevel = "WinThreshold"
        <#
            The acceptable values for this parameter are:
            Windows Server 2003: 2 or Win2003
            Windows Server 2008: 3 or Win2008
            Windows Server 2008 R2: 4 or Win2008R2
            Windows Server 2012: 5 or Win2012
            Windows Server 2012 R2: 6 or Win2012R2
            Windows Server 2016: 7 or WinThreshold
        #>

        Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools -ErrorAction SilentlyContinue

        Install-ADDSForest -DomainName $dominame -DomainMode $ADfunclevel `
        -ForestMode $ADfunclevel `
        -DatabasePath "c:\NTDS" -SYSVOLPath "c:\SYSVOL" -LogPath "c:\Logs" `
        -SafeModeAdministratorPassword $adpw `
        -force 
    }
    
    else {
        $saName = "${sa_name}"
        $saPW = "${sa_pw}" | ConvertTo-SecureString -AsPlainText -Force 
        New-ADUser -Name  $saName -AccountPassword $saPW -Passwordneverexpires $true -Enabled $true

        # Step 4 Create the OUs
        ## Adding the default account to both admin groups
        Add-ADGroupMember -Identity "domain admins" -Members $saName
        Add-ADGroupMember -Identity "enterprise admins" -Members $saName

        ## Create a few OUs to start with
        $domainpath = (Get-ADDomain).DistinguishedName
        $newOUs = "CS_Dept","SE_Dept","FIN_Dept"
        foreach ($ou in $newOUs){
            New-ADOrganizationalUnit -Name $ou -Path $domainpath
            New-ADOrganizationalUnit -Name  ($ou+"_users") -Path "OU=$ou,$domainpath"
        }


        #create AD users
        ##Change the "Default Domain Policy" to accommodate a simpler pw requirement for testing 
        $usrpw = "${domain_userPw}" | ConvertTo-SecureString -AsPlainText -Force 
        $newuser = "${domain_username}"
        New-ADUser -Name $newuser -PasswordNeverExpires $true `
        -AccountPassword $usrpw -EmailAddress "$newuser@$dominame" `
        -Enabled $true `
        -Path "OU=CS_Dept,$domainpath" 
        #Add-ADGroupMember -Identity "JumpCloud" -Members $newuser
    }
</powershell>
<persist>true</persist>
