[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$DomainAdminUser,

    [Parameter(Mandatory=$true)]
    [string]$Server,

    [Parameter(Mandatory=$true)]
    [string]$DomainDNSName
) 
try {
    $ErrorActionPreference = "Stop"
    Start-Transcript -Path C:\cfn\log\Create-Admin-User.ps1.txt -Append

    $DomainAdminPassword = (Get-SSMParameterValue -Names "ad-password").Parameters[0].Value
    Write-SSMParameter -Name "ad-password" -Type SecureString -Value $DomainAdminPassword -Overwrite $true
    $Admin = $DomainAdminUser+"@"+$DomainDNSName
    New-ADUser -Name $DomainAdminUser -UserPrincipalName $Admin -AccountPassword (ConvertTo-SecureString $DomainAdminPassword  -AsPlainText -Force) -Enabled $true -PasswordNeverExpires $true
}
catch {
    $_ | Write-AWSQuickStartException
}