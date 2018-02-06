param(
    $NetBiosName,
    $DomainDNSName
    )

$strComputerName = $NetBiosName
$aryDNSSuffixes = $DomainDNSName
invoke-wmimethod -Class win32_networkadapterconfiguration -Name setDNSSuffixSearchOrder -ComputerName $strComputerName -ArgumentList @($aryDNSSuffixes), $null