param (
    [string]$NameTag,
    [string]$User,
    [string]$Profilename
)

$ErrorActionPreference = "Stop"

$server_ip = (Get-EC2Instance -Filter @{Name = "tag:Name"; Values = $NameTag } -ProfileName $Profilename).Instances.PrivateIpAddress
if ($User -match "\\") {
    $ssm_param_name = "/credentials/ad/" + ($User -replace "\\", "/")
}
else {
    $ssm_param_name = "/credentials/local/" + $User
}
$password = (Get-SSMParameterValue -Name $ssm_param_name -WithDecryption $true -ProfileName $Profilename).Parameters.Value
cmdkey /generic:TERMSRV/$server_ip /user:$User /pass:$password
mstsc /v:$server_ip
