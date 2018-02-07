[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$DomainAdminUser,

    [Parameter(Mandatory=$true)]
    [string]$DomainDNSName
    )
try {
    $ErrorActionPreference = "Stop"
    Start-Transcript -Path C:\cfn\log\Install-ADDS-Forest.ps1.txt -Append

    $DomainAdminPassword = (Get-SSMParameterValue -Names ad-password -WithDecryption $True).Parameters[0].Value
    Install-ADDSForest -DomainName $DomainDNSName -SafeModeAdministratorPassword (ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force) -DomainMode Default -ForestMode Default  -Confirm:$false -Force
}
catch {
    $_ | Write-AWSQuickStartException
}