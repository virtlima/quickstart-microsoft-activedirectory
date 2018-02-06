
param(
    $DomainNetBIOSName,
    $DomainAdminUser,
    $DomainDNSName
    )
$DomainNetBIOSName = "'" + $DomainNetBIOSName + "\"+ $DomainAdminUser + "'"
$DomainAdminPassword = (Get-SSMParameterValue -Names ad-password -WithDecryption $True).Parameters[0].Value
echo "Debug Data..."
echo "Password:" $DomainAdminPassword
echo "DomainNetBIOSName:" $DomainNetBIOSName
echo "DomainAdminUser:" $DomainAdminUser
echo "DomainDNSName:" $DomainDNSName
Install-ADDSDomainController -InstallDns -DomainName $DomainName -Credential (New-Object System.Management.Automation.PSCredential($DomainUser,(ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force))) -SafeModeAdministratorPassword (ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force) -Confirm:$false -Force


