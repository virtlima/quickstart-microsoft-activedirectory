Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

Invoke-WebRequest -Uri https://s3.amazonaws.com/ec2-downloads-windows/EC2Config/EC2Install.zip -UseBasicParsing -OutFile "$env:temp\EC2Install.zip"

Unzip "$env:temp\EC2Install.zip" "$env:temp\EC2Install"
&"$env:temp\EC2Install\EC2Install.exe" /install /quiet /norestart
while(!(get-service AmazonSSMAgent -EA SilentlyContinue)){
    start-sleep -s 5
}
gc C:\ProgramData\Amazon\SSM\Logs\amazon-ssm-agent.log -wait