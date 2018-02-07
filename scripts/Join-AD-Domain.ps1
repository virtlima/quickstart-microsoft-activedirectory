[CmdletBinding()]
param(
    [string]
    $DomainAdminUser,

    [string]
    $DomainDNSName,

    [string]
    $DomainNetBIOSName
)

try {
    $ErrorActionPreference = "Stop"
    Start-Transcript -Path C:\cfn\log\Join-AD-Domain.ps1.txt -Append

    $DomainAdminPassword = (Get-SSMParameterValue -Names ad-password -WithDecryption $True).Parameters[0].Value
    $DomainAdmin = $DomainNetBIOSName + "\" + $DomainAdminUser
    Add-Computer -DomainName $DomainDNSName -Credential (New-Object System.Management.Automation.PSCredential($DomainAdmin, (ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force)))

    # Execute restart after script exit and allow time for external services
    $shutdown = Start-Process -FilePath "shutdown.exe" -ArgumentList @("/r", "/t 10") -Wait -NoNewWindow -PassThru
    if ($shutdown.ExitCode -ne 0) {
        throw "[ERROR] shutdown.exe exit code was not 0. It was actually $($shutdown.ExitCode)."
    }
}
catch {
    $_ | Write-AWSQuickStartException
}