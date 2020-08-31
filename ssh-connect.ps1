param (
    [string]$ServerName,
    [string]$User,
    [string]$ProfileName,
    [string]$Token
)

. (Join-Path $PSScriptRoot autologin_functions.ps1)

$ErrorActionPreference = "Stop"

# Generate the parameter name
$ssm_cred_name = "/credentials/ssh-key/" + $User
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
$ssh_key = "~\.ssh\" + $ProfileName + "_" + $User + ".pem"
## Create PEM file without BOM
$cred_text | % { [Text.Encoding]::UTF8.GetBytes($_) } | Set-Content -Path $ssh_key -Encoding Byte
ssh -i $ssh_key $User@$server_ip

# Cleanup PEM file
Remove-Item $ssh_key
