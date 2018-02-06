param(
    [string]
    $document
)
$instance_id = (New-Object System.Net.WebClient).DownloadString("http://169.254.169.254/latest/meta-data/instance-id")

New-SSMAssociation -InstanceId $instance_id -Name $document