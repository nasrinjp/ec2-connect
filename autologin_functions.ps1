function SwitchRole {
    param (
        [string]$ProfileName,
        [string]$Token
    )
    $targetrole = Get-AWSCredential -ProfileName $ProfileName
    $role = Use-STSRole -RoleArn $targetrole.RoleArn -RoleSessionName $targetrole.RoleSessionName -SerialNumber $targetrole.Options.MfaSerialNumber -TokenCode $Token
    return $role
}

function GetTargetInfo {
    param (
        [object]$Role,
        [string]$SSMCredName,
        [string]$SSMIPName
    )
    $cred_text = (Get-SSMParameterValue -Name $SSMCredName -WithDecryption $true -Credential $Role.Credentials).Parameters.Value
    $server_ip = (Get-SSMParameterValue -Name $SSMIPName -Credential $Role.Credentials).Parameters.Value
    return $cred_text, $server_ip
}
