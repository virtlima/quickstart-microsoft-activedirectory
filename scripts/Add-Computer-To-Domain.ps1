param(
    $DomainAdminUser,
    $DomainNetBIOSName,
    $DomainDNSName
    )

$DomainAdminPassword = (Get-SSMParameterValue -Names ad-password -WithDecryption $True).Parameters[0].Value
New-ADUser -Server $Server -Name $DomainAdminUser -UserPrincipalName $DomainAdminUser@$DomainDNSName -AccountPassword (ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force) -AsPlainText -Force -Enabled $true -PasswordNeverExpires $true

$DomainNetBIOSName = $DomainNetBIOSName + "\\" + $DomainAdminUser
Add-Computer -DomainName $DomainDNSName -Credential (New-Object System.Management.Automation.PSCredential($DomainNetBIOSName,(ConvertTo-SecureString $Password -AsPlainText -Force))) -Restart
