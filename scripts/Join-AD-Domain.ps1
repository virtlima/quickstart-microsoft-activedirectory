param(
    $DomainAdminUser,
    $DomainDNSName,
    $DomainNetBIOSName
)
 
$DomainAdminPassword = (Get-SSMParameterValue -Names ad-password -WithDecryption $True).Parameters[0].Value
$DomainAdmin = "'" + $DomainNetBIOSName + "\" + $DomainAdminUser + "'"
Add-Computer -DomainName $DomainDNSName -Credential (New-Object System.Management.Automation.PSCredential($DomainAdmin, (ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force))) -Restart
