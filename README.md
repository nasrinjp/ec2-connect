# rdp-connect
You can log in to Windows Server EC2 instances using RDP without typing the target server name, username and password.

## Prerequisites

### Environment
This script is available in the following versions.  
  
* PowerShell PSVersion 5
* AWS Tools for PowerShell Version 4

### Settings

* Set the Name tag value to Windows Server instances that are logged in to.
* Set the password for the username to SSM Parameter store.
    * For example, /credentials/ad/\<domain\>/\<username\>

## Usage

```
.\rdp-connect.ps1 -NameTag <name_tag_value> -User <username> -Profilename <aws_profile_name>
```