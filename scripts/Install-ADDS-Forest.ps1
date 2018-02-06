param(
    $DomainNetBIOSName,
    $DomainAdminUser,
    $DomainDNSName
    )
$DomainAdminPassword = (Get-SSMParameterValue -Names ad-password -WithDecryption $True).Parameters[0].Value
Install-ADDSForest -DomainName $DomainDNSName -SafeModeAdministratorPassword (ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force) -DomainMode Default -ForestMode Default  -Confirm:$false -Force
