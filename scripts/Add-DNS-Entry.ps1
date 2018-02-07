[CmdletBinding()]
param(
    $DomainAdminUser,
    $DomainNetBIOSName,
    $DomainDNSName,
    $ADServer1NetBIOSName,
    $ADServer1PrivateIP,
    $ADServer2PrivateIP
    )
try {
    $ErrorActionPreference = "Stop"
    Start-Transcript -Path C:\cfn\log\Add-DC.ps1.txt -Append

    $DomainAdminPassword = (Get-SSMParameterValue -Names ad-password -WithDecryption $True).Parameters[0].Value
    $DomainAdmin = $DomainNetBIOSName + "\" + $DomainAdminUser
    Invoke-Command -Scriptblock{ 
                    Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses $ADServer2PrivateIP, $ADServer1PrivateIP }
                    -ComputerName $ADServer1NetBIOSName+"."+$DomainDNSName 
                    -Credential (New-Object System.Management.Automation.PSCredential($DomainAdmin,(ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force)))

}

catch {
    $_ | Write-AWSQuickStartException
}