[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$Server,

    [Parameter(Mandatory=$true)]
    [string]$DomainAdminUser,

    [Parameter(Mandatory=$true)]
    [string]$DomainDNSName
)

try {
    $ErrorActionPreference = "Stop"
    Start-Transcript -Path C:\cfn\log\Add-AD-Account.txt -Append

    $DomainAdminPassword = (Get-SSMParameterValue -Names ad-password -WithDecryption $True).Parameters[0].Value
    New-ADUser -Server $Server -Name $DomainAdminUser -UserPrincipalName $DomainAdminUser@$DomainDNSName -AccountPassword (ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force) -AsPlainText -Force -Enabled $true -PasswordNeverExpires $true
}
catch {
    $_ | Write-AWSQuickStartException
}
