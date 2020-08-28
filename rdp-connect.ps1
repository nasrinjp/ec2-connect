param (
    [string]$ServerName,
    [string]$User,
    [string]$ProfileName,
    [string]$Token
)

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
$targetrole = Get-AWSCredential -ProfileName $ProfileName
$role = Use-STSRole -RoleArn $targetrole.RoleArn -RoleSessionName $targetrole.RoleSessionName -SerialNumber $targetrole.Options.MfaSerialNumber -TokenCode $Token

$password = (Get-SSMParameterValue -Name $ssm_cred_name -WithDecryption $true -Credential $role.Credentials).Parameters.Value
$server_ip = (Get-SSMParameterValue -Name $ssm_ip_name -Credential $role.Credentials).Parameters.Value

# Connect to the target
cmdkey /generic:TERMSRV/$server_ip /user:$User /pass:$password
mstsc /v:$server_ip
