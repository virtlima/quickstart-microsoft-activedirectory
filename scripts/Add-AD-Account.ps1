param(
    $Server,
    $DomainAdminUser,
    $DomainDNSName
    )

$DomainAdminPassword = (Get-SSMParameterValue -Names ad-password -WithDecryption $True).Parameters[0].Value
New-ADUser -Server $Server -Name $DomainAdminUser -UserPrincipalName $DomainAdminUser@$DomainDNSName -AccountPassword (ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force) -AsPlainText -Force -Enabled $true -PasswordNeverExpires $true