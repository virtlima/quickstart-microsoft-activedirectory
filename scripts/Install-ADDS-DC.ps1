
param(
    $DomainNetBIOSName,
    $DomainAdminUser,
    $DomainDNSName
    )
$DomainAdmin = $DomainNetBIOSName + "\" + $DomainAdminUser
$DomainAdminPassword = (Get-SSMParameterValue -Names ad-password -WithDecryption $True).Parameters[0].Value
Install-ADDSDomainController -InstallDns -DomainName $DomainDNSName -Credential (New-Object System.Management.Automation.PSCredential($DomainAdmin,(ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force))) -SafeModeAdministratorPassword (ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force) -Confirm:$false -Force 


