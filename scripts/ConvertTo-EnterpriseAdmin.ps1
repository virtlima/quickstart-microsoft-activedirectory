[CmdletBinding()]
param(
    [string[]]
    [Parameter(Position=0)]
    $Groups = @('domain admins','schema admins','enterprise admins'),

    [string[]]
    [Parameter(Mandatory=$true, Position=1)]
    $Members,

    [string]
    [Parameter(Mandatory=$true, Position=2)]
    $Server
)

$Groups | ForEach-Object{
    Add-ADGroupMember -Identity $_ -Members $Members -Server $Server
}