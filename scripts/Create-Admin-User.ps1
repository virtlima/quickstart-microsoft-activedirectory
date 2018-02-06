param(
    $DomainAdminUser,
    $DomainDNSName,
    $Server
) 
$DomainAdminPassword = (Get-SSMParameterValue -Names "ad-password").Parameters[0].Value
Write-SSMParameter -Name "ad-password" -Type SecureString -Value $DomainAdminPassword -Overwrite $true
$Admin = $DomainAdminUser+"@"+$DomainDNSName
New-ADUser -Name $DomainAdminUser -UserPrincipalName $Admin -AccountPassword (ConvertTo-SecureString $DomainAdminPassword  -AsPlainText -Force) -Enabled $true -PasswordNeverExpires $true