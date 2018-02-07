[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$DomainAdminUser,

    [Parameter(Mandatory=$true)]
    [string]$DomainNetBIOSName,

    [Parameter(Mandatory=$true)]
    [string]$DomainDNSName
    )
try {
    $ErrorActionPreference = "Stop"
    Start-Transcript -Path C:\cfn\log\Install-ADDS-DC.ps1.txt -Append

    $DomainAdmin = $DomainNetBIOSName + "\" + $DomainAdminUser
    $DomainAdminPassword = (Get-SSMParameterValue -Names ad-password -WithDecryption $True).Parameters[0].Value
    Install-ADDSDomainController -InstallDns -DomainName $DomainDNSName -Credential (New-Object System.Management.Automation.PSCredential($DomainAdmin,(ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force))) -SafeModeAdministratorPassword (ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force) -Confirm:$false -Force 
}
catch {
    $_ | Write-AWSQuickStartException
}