param (
    [string]$ServerName,
    [string]$User,
    [string]$ProfileName,
    [string]$Token
)

. (Join-Path $PSScriptRoot autologin_functions.ps1)

$ErrorActionPreference = "Stop"

# Generate the parameter name
## For AD users
if ($User -match "\\") {
    $ssm_cred_name = "/credentials/ad/" + ($User -replace "\\", "/")
}
## For local users
else {
    $ssm_cred_name = "/credentials/local/" + $ServerName + "/" + $User
}
$ssm_ip_name = "/ip-address/" + $ServerName

# Get the target information
if ($ProfileName -and $Token) {
    $role = SwitchRole -ProfileName $ProfileName -Token $Token
    $target_info = GetTargetInfo -Role $role -SSMCredName $ssm_cred_name -SSMIPName $ssm_ip_name
}
else {
    $target_info = GetTargetInfo -SSMCredName $ssm_cred_name -SSMIPName $ssm_ip_name
}
$cred_text, $server_ip = $target_info

# Connect to the target
cmdkey /generic:TERMSRV/$server_ip /user:$User /pass:$cred_text
mstsc /v:$server_ip
