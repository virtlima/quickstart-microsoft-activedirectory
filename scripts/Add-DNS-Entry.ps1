param(
    $DomainAdminUser,
    $DomainNetBIOSName,
    $DomainDNSName,
    $ADServer1NetBIOSName,
    $ADServer1PrivateIP,
    $ADServer2PrivateIP
    )
$DomainAdminPassword = (Get-SSMParameterValue -Names ad-password -WithDecryption $True).Parameters[0].Value
$DomainNetBIOSName = "'" + $DomainNetBIOSName + "\\"+ $DomainAdminUser + "'"
Invoke-Command -Scriptblock{ 
                    Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses $ADServer2PrivateIP, $ADServer1PrivateIP }
                    -ComputerName $ADServer1NetBIOSName+"."+DomainDNSName 
                    -Credential (New-Object System.Management.Automation.PSCredential($DomainNetBIOSName,(ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force)))
