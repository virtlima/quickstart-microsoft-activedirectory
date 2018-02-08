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
    $FQDN = $ADServer1NetBIOSName+"."+$DomainDNSName
    Invoke-Command -ComputerName $FQDN -Credential (New-Object System.Management.Automation.PSCredential($DomainAdmin,(ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force))) -Scriptblock { 
                    Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses $ADServer2PrivateIP, $ADServer1PrivateIP 
    }
                    
                    

}

catch {
    $_ | Write-AWSQuickStartException
}