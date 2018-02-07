[CmdletBinding()]
param(
    $Server,
    $DomainAdminUser,
    $DomainDNSName,
    $DomainNetBIOSName
)

try {
    $ErrorActionPreference = "Stop"
    Start-Transcript -Path C:\cfn\log\Add-DC.ps1.txt -Append

    $secure = (Get-SSMParameterValue -Names ad-password -WithDecryption $True).Parameters[0].Value
    $DomainAdminPassword = "'" + $server "'"
    $DomainUser = "'" + $DomainNetBIOSName + '\\' + $DomainAdminUser
    Install-ADDSDomainController -InstallDns -DomainName $DomainDNSName -Credential New-Object System.Management.Automation.PSCredential($DomainUser) -SafeModeAdministratorPassword (((ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force))) -Confirm:$false -Force
}

catch {
    $_ | Write-AWSQuickStartException
}