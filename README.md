# EC2-connect
You can log in to Windows Server or Linux Server EC2 instances from your Windows PC without password.

## Prerequisites
This scripts can be executed in your Windows PC or Windows Server EC2 instances.

### Environment
This script is available in the following versions.  
  
* PowerShell PSVersion 5
* AWS Tools for PowerShell Version 4

### Settings
You need to set the following parameters to SSM Parameter store.

* Set the password or SSH key for the username.
    * For example, /credentials/ad/\<domain\>/\<username\>
    * For example, /credentials/local/\<Name tag\>/\<username\>
    * For example, /credentials/ssh-key/\<username\>
* Set the IP address you want to login.
    * For example, /ip-address/\<Name tag\>

You need to create .ssh directory in your home directory.

```
cd ~
mkdir .ssh
```

If this scripts is used from Windows Server EC2 instances, you need to attach the IAM role to Windows Server EC2 instances.

## Usage

```
# For Windows Server from Windows Server EC2 instances
.\rdp-connect.ps1 -ServerName <name_tag_value> -User <username>

# For Windows Server from your Windows PC
.\rdp-connect.ps1 -ServerName <name_tag_value> -User <username> -ProfileName <aws_profile_name> -Token <MFA_token_for_aws_profile>

# For Linux Server from Windows Server EC2 instances
.\ssh-connect.ps1 -ServerName <name_tag_value> -User <username>

# For Linux Server from your Windows PC
.\ssh-connect.ps1 -ServerName <name_tag_value> -User <username> -ProfileName <aws_profile_name> -Token <MFA_token_for_aws_profile>
```
