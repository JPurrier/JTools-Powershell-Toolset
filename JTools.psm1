# JTools Verson 1.9.66  (C) Fobultech Ltd 2017
# Use the Update-Jtoolset command to to update the the latest version of Jtools a HTTP connection is required for this to work


function Move-AllVmsToNewServer {
<#
.SYNOPSIS
JP's Move VM's From one Server to another.
 
.DESCRIPTION
Move-AllVmsToNewServer Will take all the servers on one host and move them to another. 

.PARAMETER HOSTSERVER
One or more computer names or IP addresses.

.EXAMPLE
 Move-AllVmsToNewServer -SOURCESERVER HOST1 -DestinationServer HOST2.
 #>

        [CmdletBinding()]
        param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Enter the name of the server to be evacuated")]
        [Alias('hostname,Servername')]
        [string]$Sourceserver,
        [Parameter(Mandatory=$True,
                   HelpMessage="Enter the name of the Destination server")]
        [string]$DestinationServer
    )
   
    BEGIN {
       Try { Import-Module FailoverClusters -ErrorAction Stop }
       Catch { Write-Host "Unable to load FailoverClusters Module, appears this feature is not availible on this server"; Break }
      <#  Try {Import-Module hyperv -ErrorAction Stop }
       Catch { Write-Host "Unable to load HyperV Module, appears this feature is not availible on this server"; Break }
      [For Version 2.0]$ClusterNodes_FreeMem = get-clusternode |where {$_.Name -notlike $currenthost} |where {$_.State -like "Up"} |foreach {get-WmiObject win32_operatingsystem -computername $_.name |Select-object @{L='FreePhysicalMemory';E={($_.FreePhysicalMemory)*1KB/1GB}},CSName} |sort-object FreePhysicalMemory -Descending
       $BestHostN = $ClusterNodes_FreeMem | select CSName -first 1
       $BestHostM = $ClusterNodes_FreeMem | select FreePhysicalMemory -first 1 #>
       
            }

                PROCESS {
                $VMLIST = get-clustergroup |where {$_.OwnerNode -like $SOURCESERVER} | where {$_.name -like ("*$($vm.VMElementName)*")}
              
              
                        foreach ($Guest in $VMLIST) 
                                                    {
                                                 Move-ClusterVirtualMachineRole $Guest -Node $DestinationServer
                                                    }

                        }

}

function Get-JToolsCommand {
<#
.SYNOPSIS
Get-JtoolsCommand Displays a list of all the Jtool CMDLETS
 
.DESCRIPTION
Get-JtoolsCommand Displays a list of all the Jtool CMDLETS 

.EXAMPLE
Get-JtoolsCommand
 #>

                                $JTOOLSCommands = @{

                                “Move-AllVmsToNewServer” = "Move VM's From one Hyper-V Server to another"; “Get-JToolsCommand” = 
                                "View Availible JTtools Commands"; "Reset-AdPassword"= "Reset AD Users Password"; "Get-DellServiceTag" = "Displays the Service Tag number/ Serial of a machine";
                                "Get-DelliDracIP" = "Shows the Idrac IP Details for servers"; "Get-SystemInfo" = "Display useful information about a Machine";
                                "Copy-JCopy" = "Copys files from one location to another via robocopy" ;
                                "Clone-ComputerGroups" = "Copys the computer groups from one computer and applies them to another";
                                "Clone-UserGroups" = "Copys the User groups from one User and applies them to another use the replace switch to replace all permissions";
                                "Ping-Test" = "Makes it easy to ping a server for any specified number of minutes"; "Get-HPilo" = "Get iLo info from HP Servers";
                                "Get-PercentageDifference" = "Works out the percentage increase or decrease between two values";
                                "Get-ADGroupMembership" = "Gets the Group Membership of a User or Computer Account in AD";
                                "Get-InstalledSoftware" = "Shows all the installed software on a machine"; "Update-Jtoolset" = "Updates Jtools to the latest version requires a internet connection";
                                "Get-JtoolsVersion" = "Shows version of Jtools"; "Zip-Folder" = "Will compress a folder with the zip format"; "Unzip-Folder" = "Unzip's zip files";
                                "Deploy-Jtools" = "Will deploy Jtools to specified machine"; "Compare-hotfix" = "Compare hotfix's between machines"; 
                                "Measure-LDAPRequestSpeed" = "Measure response Times of a DC"; "Clone-GroupUsers" = "copys the groups members from one group and moves them to another another";
                                "Create-ADUsers" = "Use this tool to bulk creat AD user(s)";"Generate-LogEvent" = "Creates a CSV log file of the data you feed into Object & message"
                                }
                                
                               
                                $JTOOLArray = @()

                                Foreach ($item in $jtoolscommands.GetEnumerator())
                                {
                                $Obj = New-Object PsObject
                                $obj | Add-Member -Name "Command" -MemberType NoteProperty -Value $Null
                                $obj | Add-Member -Name "Description" -MemberType NoteProperty -Value $Null

                               $Obj.Command = $item.Key
                               $Obj.Description = $item.Value
                               $JTOOLArray += $Obj
                              
                                
                                }
                                
                               $JTOOLArray
                                

                                }

function Reset-AdPassword {

<#
.SYNOPSIS
JP's Reset-AdPassword tool resets users passwords. Forces Change password at next Logon
 
.DESCRIPTION
Reset User passwords  

.PARAMETER HOSTSERVER
One or more Users reset password 

.EXAMPLE
Reset-AdPassword -UserName JohnD 

.EXAMPLE
Reset-AdPassword -UserName JohnD -NoPrompt

.EXAMPLE
Get-aduser JohnD | Reset-AdPassword 
 #>

[CmdletBinding()]
        param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Enter the name of the user to reset",
                   Position=0)]
        [Alias('Identity')]
        [string]$UserName,
        [Parameter(
                   Position=1)]
        $Password = ( Read-Host "Input New Password" -AsSecureString ), 
        [switch]$NoPrompt
        
        )
       


        BEGIN   {
                Try {   Import-Module ActiveDirectory -ErrorAction Stop }
                Catch { Write-Host "Unable to load Actve Directory Powershell Module appears this feature is not availible on this machine" ; Break}
                }

        PROCESS {

                If ($NoPrompt) { foreach ($UserName1 in $UserName) {
                
                Set-AdaccountPassword -Identity $UserName1 -Reset -NewPassword  $Password  
                Write-Host "You have chosen to change the password of $UserName1 without them needing to change password at next logon" 
                $UserStatus = get-aduser $UserName1 -prop LockedOut
                  if (($UserStatus.LockedOut) -eq "$false") { Write-Warning "$UserName1 is locked out. to enable use the Unlock-ADaccount CMDLET"}
                  if (($UserStatus.Enabled)-ne "$True")  { Write-Warning "$UserName1 is not enabled to enable use the Enable-ADaccount CMDLET"}
                                                                    }
                                }
                                

                Else {

                                foreach ($UserName1 in $UserName) {
				                                                    Set-AdaccountPassword -Identity $UserName1 -Reset -NewPassword  $Password  
                                                    
                                                                    Get-ADUser $UserName1 | Set-ADUser -ChangePasswordAtLogon $true
                                                                    Write-Host "You have chosen to change the password of $userName1 This user will be prompted to change password at next logon" 
                                                                    $UserStatus = get-aduser $UserName1 -prop LockedOut
                                                                    if (($UserStatus.LockedOut) -eq "$false") { Write-Warning "$UserName1 is locked out. to enable use the Unlock-ADaccount CMDLET"}
                                                                    if (($UserStatus.Enabled)-ne "$True")  { Write-Warning "$UserName1 is not enabled to enable use the Enable-ADaccount CMDLET"}
                                                                    }
                     }
                
                }

}


Function Get-DellServiceTag {
<#
.SYNOPSIS
JP's Get-DellServiceTag Shows the Dell Service Tag
 
.DESCRIPTION
Shows the Dell Service Tag  

.PARAMETER ComputerName
One or more ComputerNames

.EXAMPLE
Get-DellServiceTag -ComputerName Host1 


 #>

                [CmdletBinding()]
        param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Enter the name of the user to reset",
                   Position=0)]
        [Alias('Identity','HOST')]
        [string]$ComputerName)

        PROCESS { 
        
                    if (Test-Connection $ComputerName -Quiet) {

                                                            $ServiceTag = Get-WmiObject win32_bios -ComputerName $ComputerName
                                                            $ServiceTag | select @{Name="ServiceTag";Expression={$_."SerialNumber"}} 
                                                        }
                    Else {Write-Host -ForegroundColor Red "Connection to Machine Failed"}
                  
                  
                  
                  
                  }

}

Function Get-DellIdracIP {

<#
.SYNOPSIS
Jerome's Get-DellIdracIP Shows the Dell IDrac IP address
 
.DESCRIPTION
Shows the Dell IDrac IP address 

.PARAMETER ComputerName
One or more ComputerNames

.EXAMPLE
Get-DellIdracIP -ComputerName Host1 
#>
        [CmdletBinding()]
        param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Enter the name of Server",
                   Position=0)]
        [Alias('Identity','Computer')]
        [string]$HostName)

            IF (Test-Connection $HostName <#-Quiet#>) 

            {
                                                       Write-Host "Connection Successful for $HostName"

                                                        IF (Get-WMIObject -ComputerName $HostName -Namespace ROOT\CIMV2 -Class __NAMESPACE -filter "name='DELL'") {
                                                       Write-Host "Namespace Found for $HostName"
        
                                                        $WMIEntries = Get-WmiObject -ComputerName $HostName -Namespace ROOT\CIMV2\Dell -Class Dell_RemoteAccessServicePort 

                                                       $WMIEntries

    
                                                     }

        
        Else {Write-Host "Server Does not appear to have idrac"}



             }

        Else { Write-Host "Unable to connect to server"}

}

function Get-SystemInfo {
<#
.SYNOPSIS
Retrieves key system version and model information
from one to ten computers.
.DESCRIPTION
Get-SystemInfo uses Windows Management Instrumentation
(WMI) to retrieve information from one or more computers.
Specify computers by name or by IP address.
.PARAMETER ComputerName
One or more computer names or IP addresses, up to a maximum
of 10.
.PARAMETER LogErrors
Specify this switch to create a text log file of computers
that could not be queried.
.PARAMETER ErrorLog
When used with -LogErrors, specifies the file path and name
to which failed computer names will be written. Defaults to
C:\Retry.txt.
.EXAMPLE
 Get-Content names.txt | Get-SystemInfo
.EXAMPLE
 Get-SystemInfo -ComputerName SERVER1,SERVER2
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Computer name or IP address")]
        [ValidateCount(1,10)]
        [Alias('hostname')]
        [string[]]$ComputerName,

        [string]$ErrorLog = $MOLErrorLogPreference,

        [switch]$LogErrors
    )
    BEGIN {
        Write-Verbose "Error log will be $ErrorLog"
    }
    PROCESS {
        Write-Verbose "Beginning PROCESS block"
        foreach ($computer in $computername) {
            Write-Verbose "Querying $computer"
            Try {
                $everything_ok = $true
                $os = Get-WmiObject -class Win32_OperatingSystem `
                                    -computerName $computer `
                                    -erroraction Stop
            } Catch {
                $everything_ok = $false
                Write-Warning "$computer failed"
                if ($LogErrors) {
                    $computer | Out-File $ErrorLog -Append
                    Write-Warning "Logged to $ErrorLog"
                }
            }

            if ($everything_ok) {
                $comp = Get-WmiObject -class Win32_ComputerSystem `
                                      -computerName $computername
                $bios = Get-WmiObject -class Win32_BIOS `
                                      -computerName $computername
                $IP = gwmi Win32_NetworkAdapterConfiguration -ComputerName $ComputerName | select IPAddress, description | Where { $_.IPAddress }
                $Uptime = Get-WmiObject win32_operatingsystem -ComputerName $ComputerName 
                $UP2 = [Management.ManagementDateTimeConverter]::ToDateTime($uptime.InstallDate)
                $boot = [Management.ManagementDateTimeConverter]::ToDateTime($uptime.LastBootUpTime)
                
                switch -Wildcard ($Uptime.version){ 
                "5.0*" {$OSv = "Windows 2000 (Out of MS Support)"}
                "5.1*" {$OSv = "Windows XP (Out of MS Support)"}
                "5.2*" {$OSv = "Windows XP 64Bit/ Server 2003 / Server 2003 R2 (Out of MS Support)"}
                "6.0*" {$OSv = "Windows Server 2008"}
                "6.1*" {$OSv = "Windows Server 2008R2 / Windows 7"}
                "6.2*" {$OSv = "Windows Server 2012 / Windows 8"}
                "6.3*" {$OSv = "Windows Server 2012 R2 / Windows 8.1"}
                "10*" {$OSv = "Windows 10 or Greater"}
                default {$OSv = "OS Uknown"}

                }


                $props = @{'Computer Name'=$computername;
                           'OS Version'=$os.version;
                           'SP Version'=$os.servicepackmajorversion;
                           'BIOS Serial'=$bios.serialnumber;
                           'Manufacturer'=$comp.manufacturer;
                           'Model'=$comp.model;
                           'IP Adressess' = $IP.IPAddress;
                           'Network Card' = $IP.description;
                           'LastBootTime' = [Management.ManagementDateTimeConverter]::ToDateTime($uptime.LastBootUpTime);
                           'OSArchitecture' = $Uptime.OSArchitecture;
                           'Total RAM (GB)' = [math]::Round($Uptime.TotalVisibleMemorySize / 1MB);  
                           'Original Install Date' = $UP2; 
                           'OS Name' = $OSv
                           
                           }
                Write-Verbose "WMI queries complete"
                $obj = New-Object -TypeName PSObject -Property $props
                $obj.PSObject.TypeNames.Insert(0,'MOL.SystemInfo')
                Write-Output $obj
            }
        }
    }
    END {}
}


Function Copy-JCopy {
<#
.SYNOPSIS
JP's Copy-JCopy tool copys data from one location to another 
 
.DESCRIPTION
Copys data from one location to another using Robo Copy with the follwing switched "/E /R:6 /W:5 /MT:64 /SEC"

.PARAMETER Source
The source files to be coppied 

.PARAMETER Destination
The Destination location for the files and folders

.EXAMPLE
copy-jcopy -Source \\Share\FolderName -Destination \\Folder1\Folder2




 #>

[CmdletBinding()]
        param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Enter the source files to be coppied",
                   Position=0)]
        [string]$Source,
        [Parameter(Mandatory=$True,
                   HelpMessage="Enter the destination location for the files and folders",
                   Position=1)]
        [string]$Destination)
       

                        
          PROCESS {              
                             robocopy $Source $Destination /E /R:6 /W:5 /MT:64 /SEC 
                                                        
                       
                    }

}

Function Clone-ComputerGroups {
<#
.SYNOPSIS
JP's Clone-ComputerGroups tool copys the computer groups from one computer and applies them to another
 
.DESCRIPTION
Copys the computer groups from one computer and applies them to another

.PARAMETER Source
The source computer who groups are to be coppied 

.PARAMETER Destination
The Destination computer to have groups added

.EXAMPLE
Clone-ComputerGroups -Source Computer1 -Destination Computer2

.EXAMPLE
Clone-ComputerGroups Computer1 Computer2




 #>

[CmdletBinding()]
        param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Enter the source Computer whos groups are to be coppied",
                   Position=0)]
        [string]$Source,
        [Parameter(Mandatory=$True,
                   HelpMessage="Enter the destination Computer for the Groups to be added to",
                   Position=1)]
        [string]$Destination)
       

            BEGIN {
                Try {   Import-Module ActiveDirectory -ErrorAction Stop }
                Catch { Write-Host "Unable to load Actve Directory Powershell Module appears this feature is not availible on this machine" ; Break}
                }



        PROCESS { $Groups =  Get-ADComputer $Source -properties memberof | select-object -expandproperty memberof 
                    IF ($Destination -like "*$") { foreach ($group in $Groups) {Add-ADGroupMember -identity $group -members $Destination } }
                    Else {foreach ($group in $Groups) {Add-ADGroupMember -identity $group -members "$Destination$"} }
                }
                        
       

}
Function Clone-UserGroups {
<#
.SYNOPSIS
JP's Clone-UserGroups  copys the User groups from one User and applies them to another use the replace switch to replace all permissions
 
.DESCRIPTION
copys the User groups from one User and applies them to another use the replace switch to replace all permissions

.PARAMETER Source
The source User who groups are to be coppied 

.PARAMETER Destination
The Destination User to have groups added or replaced with the (-Replace) Switch

.EXAMPLE
Clone-UserGroups -Source User1 -Destination User2

.EXAMPLE
Clone-ComputerGroups User1 User2

.EXAMPLE
Clone-ComputerGroups User1 User2 -replace




 #>
[CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact=’High’)]
        param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Enter the source User whos groups are to be coppied",
                   Position=0)]
        [string]$Source,
        [Parameter(Mandatory=$True,
                   HelpMessage="Enter the destination Computer for the Groups to be added to",
                   Position=1)]
        [string]$Destination,
        [Parameter(HelpMessage="Use -Replace to remove all permissions on Destination an replace with source"
       )]
        [switch]$Replace)

 BEGIN {
                Try {   Import-Module ActiveDirectory -ErrorAction Stop }
                Catch { Write-Host "Unable to load Actve Directory Powershell Module appears this feature is not availible on this machine" ; Break}
                }


PROCESS { $Groups =  Get-ADuser $Source -properties memberof | select-object -expandproperty memberof 
            
                    IF ($replace) {
                                    $Rem = Get-ADuser $Destination -properties memberof | select-object -expandproperty memberof 
                                    foreach ($REM1 in $REM) {remove-adgroupmember -identity $rem1 -member $Destination -Confirm:$false}
                                    foreach ($group in $Groups) {Add-ADGroupMember -identity $group -members $Destination }
                                    
                                    }

                    Else {foreach ($group in $Groups) {Add-ADGroupMember -identity $group -members $Destination } }
        }


}

Function Ping-Test {
<#
.SYNOPSIS
JP's Ping-Test makes it easy to ping a server for any specified number of minutes
 
.DESCRIPTION
JP's Ping-Test makes it easy to ping a server for any specified number of minutes

.PARAMETER Computer
Machine to ping

.PARAMETER Duration
Number of minutes to ping


.PARAMETER Duration
Log file location

.EXAMPLE
Ping-Test -Computer Computer1 -Duraton 10 -Logfile c:\Pinglog.txt

.EXAMPLE
Ping-Test Computer1 10

.EXAMPLE
Ping-Test Computer1 10 c:\pinglog.txt




 #>

[CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact=’High’)]
        param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Enter Computer to ping",
                   Position=0)]
        [string]$Computer,
        [Parameter(Mandatory=$True,
                   HelpMessage="Enter the number of minutes to ping for",
                   Position=1)]
        [string]$Duration,
         [Parameter(
                   HelpMessage="Enter the Lofile Location",
                   Position=2)]
        [string]$Logfile)

        PROCESS {
                    $time = Get-date
                    $UserTime = $time.AddMinutes(+$Duration)


                        While ((Get-date) -le "$userTime")
                                                { 
                                                  IF ($Logfile) {  Test-Connection $Computer | Out-File $Logfile -append }
                                                  Else { Test-Connection $Computer}
                                                }

                }
      


}

Function  Get-PercentageDifference {

<# 

.SYNOPSIS
JP's Get-PercentageDifference Will show the percentage increase or decrease between two values.
 
.DESCRIPTION
Show the percentage increase or decrease between two values.

.PARAMETER Value1
The Original Value. 

.PARAMETER Value2
The New Value2 

.EXAMPLE
Get-PercentageDifference 10 100

.EXAMPLE
Get-PercentageDifference -Value1 10 -Value2 100

#>


[CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact=’High’)]
        param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Enter Original value",
                   Position=0)]
        [int]$Value1,
        [Parameter(Mandatory=$True,
                   HelpMessage="Enter what the value is now",
                   ValueFromPipelineByPropertyName=$True,
                   Position=1)]
        [int]$Value2,
        [Parameter()]
        [switch]$OutputValueOnly
        
        )


                                PROCESS {

                                If ($OutputValueOnly)
                                {
                                            $Difference = $value2-$Value1
                                            $Percentage = $Difference/$Value1*100
                                            $Percentage


                                }
                                Else {
                                            $Difference = $value2-$Value1
                                            $Percentage = $Difference/$Value1*100

                                            if ($Percentage -gt "0") { Write-Host -ForegroundColor Green "Percentage has increased by: $Percentage%"}
                                            if ($Percentage -le "0") { Write-Host -ForegroundColor Red "Percentage has decreased by: $Percentage%"}
                                      }
                                        }






}

Function Get-HPilo {
# 
<#
.SYNOPSIS
JP's Get-HPilo Shows the HP ilo Details
 
.DESCRIPTION
Shows the Dell Service Tag  

.PARAMETER ComputerName
One or more ComputerNames

.EXAMPLE
Get-HPilo -ComputerName Host1 


 #>

                [CmdletBinding()]
        param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Enter the name of the Host to Queiry",
                   Position=0)]
        [Alias('Identity','HOST')]
        [string]$ComputerName)

        PROCESS { 
                   Foreach ($Computer in $computername) {
                                                           $ilo=get-wmiobject -class hp_managementprocessor -computername $Computer -namespace root\HPQ  
                                                           
                                                           IF ($ilo) {$ilo}
                                                           Else { Write-Host "It appears this server does not have ilo"}
                                                        }
                
                }



}

Function Clone-FolderPermissions {
<#
.SYNOPSIS
JP's Clone-FolderPermissions Replaces Permissions on a destinations folder with a sources
 
.DESCRIPTION
Replaces Permissions on a destinations folder with a sources 

.PARAMETER SourceFolder
One Source Folders to Copy Permissions 

.PARAMETER DestinationFolder
One or more Destination Folders to receive permissions

.EXAMPLE
Clone-FolderPermissions "c:\Server1\Source Folder" "c:\Server1\Destination Folder"

.EXAMPLE
Clone-FolderPermissions -SourceFolder $ACLfolder -DestinationFolder $ACLFolder
$Folders = Get-Content "C:\List of folders to replace permisions.txt"
$ACLfolder = "c:\FolderToCopyPermissions"


#>


                [CmdletBinding()]
        param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Enter Source Folder",
                   Position=0)]
                [string]$SourceFolder,
                [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Enter Source Folder",
                   Position=1)]
                   [string]$DestinationFolder
              )


        BEGIN    {
                    if    ( Test-Path $SourceFolder ) { }
                    Else  { Write-Output "Unable to Validate Source folder" ; Break}
                        

                  }



        PROCESS {
                    $SourceACL = Get-ACL $SourceFolder
                    FOREACH ($Folder in $DestinationFolder) {
                                                               SET-ACL –path $Folder -AclObject $SourceACL
                                                               

                                                              }

                                                            

                 }


}

Function Get-ADGroupMembership {
<#
.SYNOPSIS
JP's Get-ADGroupMembership Displays a Users AD Group Membership
 
.DESCRIPTION
Displays a Users or Computers AD Group Membership

.PARAMETER Identity
Identity of user or computer


.EXAMPLE
Get-ADGroupMembership  User1

.EXAMPLE
Get-ADGroupMembership  Computer1


#>

                [CmdletBinding()]
        param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Enter User or computer Identity",
                   Position=0)]
                [string]$Identity
               
              )

        BEGIN    {
                Try {   Import-Module ActiveDirectory -ErrorAction Stop }
                Catch { Write-Host "Unable to load Actve Directory Powershell Module appears this feature is not availible on this machine" ; Break}
                }

        PROCESS {
                    Try { $User = Get-ADUser $Identity -Properties memberof}
                    Catch {}

                    Try { $computer = Get-ADComputer $Identity -prop memberof}
                    Catch {}

                    if ($User) {$User | select -ExpandProperty memberof | Get-ADGroup | Select Name,GroupScope,GroupCategory}
                    Elseif ($computer) {$computer | select -ExpandProperty memberof | Get-ADGroup | Select Name,GroupScope,GroupCategory}
                    Else {Write-Host -ForegroundColor DarkRed "Unable to complete task check user or computer name"}

                }


}

Function Get-InstalledSoftware {
<#
.SYNOPSIS
JP's Get-InstalledSoftware Displays all installed software on machines uses WMI.
 
.DESCRIPTION
Displays all installed software on machines uses WMI.

.PARAMETER Computer
Name of machine


.EXAMPLE
Get-InstalledSoftware Computer1

.EXAMPLE
Get-InstalledSoftware Computer1 -Filter "Microsoft Word"


#>


                [CmdletBinding()]
        param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Enter computer Name",
                   Position=0)]
                [string]$Computer,
                 [Parameter(Mandatory=$False,
                   ValueFromPipeline=$False,
                   
                   HelpMessage="For additional info use this switch",
                   Position=1)]
                [switch]$Detailed,
                    [Parameter(Mandatory=$False,
                   ValueFromPipeline=$False,
                   
                   HelpMessage="provide a search word"
                   )]
                [string]$Filter
               
              )

          
          PROCESS {
                        if ($Detailed) { Get-WmiObject -Class Win32_Product -ComputerName $Computer}
                        if ($Filter) { Get-WmiObject -Class Win32_Product -ComputerName $Computer | where {$_.Name -like "*$Filter*"}}
                        Else { Get-WmiObject -Class Win32_Product -ComputerName $Computer | select Name}

                  }


}

Function Zip-Folder {
<#
.SYNOPSIS
JP's Zip-Folder Zips Files via .Net Framework.
 
.DESCRIPTION
Zip-File Zips Files via .Net Framework

.PARAMETER Source
Enter or path of folder to zip

.PARAMETER Destination
Enter the path to Create Zip Archive

.PARAMETER DeleteOriginal
This will delete original File


.EXAMPLE
Zip-Folder C:\Archive c:\Archive.zip

.EXAMPLE
Zip-Folder -Source C:\Archive -Destination c:\Archive.zip -DeleteOriginal


#>
 [CmdletBinding()]
        param( 
        [Parameter (Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, HelpMessage="Enter or path of folder to zip", Position=0)]
        [String]$Source,
        [Parameter (Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, HelpMessage="Enter the path to Create Zip Archive", Position=2)]
        [String]$Destination,
        [Parameter(Mandatory=$False, ValueFromPipeline=$False, HelpMessage="This will delete original File")]
        [switch]$DeleteOriginal          
   
             )

PROCESS {

             If ($DeleteOriginal) {

                                   Add-Type -assembly "system.io.compression.filesystem"
                                   [io.compression.zipfile]::CreateFromDirectory($Source, $Destination)
                                   Remove-item "$Source" -Recurse }

             ELSE {
                                   Add-Type -assembly "system.io.compression.filesystem"                                     
                                   [io.compression.zipfile]::CreateFromDirectory($Source, $Destination)  
                                   

                                    }
             
         }

}

Function UnZip-Folder {
<#
.SYNOPSIS
JP's UnZip-File Zips Files via .Net Framework.
 
.DESCRIPTION
Zip-File Zips Files via .Net Framework

.PARAMETER Source
Enter or path of folder to zip

.PARAMETER Destination
Enter the path to Create Zip Archive

.PARAMETER DeleteOriginal
This will delete original File


.EXAMPLE
Zip-Folder C:\Archive.zip c:\Archive.zip

.EXAMPLE
Zip-Folder -Source C:\Archive.zip -Destination c:\Archive.zip -DeleteOriginal


#>
 [CmdletBinding()]
        param( 
        [Parameter (Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, HelpMessage="Enter or path of folder to zip", Position=0)]
        [String]$Source,
        [Parameter (Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, HelpMessage="Enter the path to Create Zip Archive", Position=2)]
        [String]$Destination,
        [Parameter(Mandatory=$False, ValueFromPipeline=$False, HelpMessage="This will delete original File")]
        [switch]$DeleteOriginal          
   
             )

PROCESS {

             If ($DeleteOriginal) {

                                   Add-Type -assembly "system.io.compression.filesystem"
                                   [System.IO.Compression.ZipFile]::ExtractToDirectory($Source, $Destination)
                                   Remove-item "$Source" -Recurse}

             ELSE {
                                   Add-Type -assembly "system.io.compression.filesystem"                                     
                                   [System.IO.Compression.ZipFile]::ExtractToDirectory($Source, $Destination)  
                                   

                                    }
             
         }

}

Function Update-Jtoolset {
<#
.SYNOPSIS
JP's Update-Jtoolset updates Jtools from the internet to the latest version
 
.DESCRIPTION
Update-Jtoolset updates Jtools from the internet to the latest version

.PARAMETER UseProxy
Will use your IE proxy settings and will ask for username and password

.EXAMPLE
Update-Jtoolset 

.EXAMPLE
Update-Jtoolset -UseProxy
#>
    [CmdletBinding()]
    Param (
    [Parameter(Mandatory=$False, ValueFromPipeline=$False, HelpMessage="This will force the use of proxy")]
    [Alias('Proxy')]
    [switch]$UseProxy )

    $temp  =  $env:temp
    $temp1 = "$temp\Jtools.psm1"
    $source = "http://fobultech.com/jtools/JTools.psm1"
    $destination = "$temp1"
    $SystemRoot = $env:SystemRoot
    $JtoolsPath = "$SystemRoot\System32\WindowsPowerShell\v1.0\Modules\JTools"
 
IF ($UseProxy)  {  
                $Version = Get-JtoolsVersion
                Write-Host "Jtools Current Version info: $version"
                Write-host "Updating Jtools Now..."
                $webclient=New-Object System.Net.WebClient 
                $creds=Get-Credential 
                $webclient.Proxy.Credentials=$creds
                Try {Invoke-WebRequest $source -OutFile $destination }
                Catch {Write-Host "Opps Jtools Could not update! Error Below" -ForegroundColor DarkRed
                        $ErrorMessage = $_.Exception.Message
                        $FailedItem = $_.Exception.ItemName
                        Write-Host "$FailedItem"
                        Write-Host "$ErrorMessage" ; Break
                }
                copy-item $destination $JtoolsPath
                Write-Output "Please close and re-open powershell window for update to take effect" 
                $Version = Get-JtoolsVersion
                Write-Output "Updated info: $version"
                
                }
Else            {
                $Version = Get-JtoolsVersion
                Write-Output "Jtools Current Version info: $version"
                Write-Output "Updating Jtools Now..."
                Try {Invoke-WebRequest $source -OutFile $destination }
                Catch { Write-Host "Opps Jtools Could not update! If your using a proxy please use the 'Update-Jtools -UseProxy' Command" -ForegroundColor DarkRed
                        $ErrorMessage = $_.Exception.Message
                        $FailedItem = $_.Exception.ItemName
                        Write-Output "$FailedItem"
                        Write-Output "$ErrorMessage" ; Break
                      }
                
                copy-item $destination $JtoolsPath
                Write-Output "Please close and re-open powershell window for update to take effect"
                $Version = Get-JtoolsVersion
                Write-Output "Updated info: $version"
                              
                }


} 
Function Get-JtoolsVersion {
$SystemRoot = $env:SystemRoot
$JtoolsPath = "$SystemRoot\System32\WindowsPowerShell\v1.0\Modules\JTools\jtools.psm1"
$version = Get-Content $JtoolsPath  | select -first 1
Write-output "$version"

}

Function Deploy-Jtools {
[CmdletBinding()]
        param( 
        [Parameter (Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, HelpMessage="Enter or path of folder to zip", Position=0)]
        [String]$ComputerName )

PROCESS {
$SystemRoot = $env:SystemRoot
Try {Test-Path "$SystemRoot\System32\WindowsPowerShell\v1.0\Modules\JTools\jtools.psm1"}
Catch {Write-host "Opps lookes like Jtools is not in the location: $SystemRoot\System32\WindowsPowerShell\v1.0\Modules\JTools\jtools.psm1" ; Break} 

Copy-JCopy "$SystemRoot\System32\WindowsPowerShell\v1.0\Modules\JTools" "\\$computerName\c$\Windows\System32\WindowsPowerShell\v1.0\Modules\JTools"


}


}

Function Compare-Hotfix 
{
<#
.SYNOPSIS
JP's Compare-Hotfix Will tell you what Patches are different from your reference machine
 
.DESCRIPTION
Will tell you what Patches are different from your reference machine


.EXAMPLE
Compare-Hotfix  Server1 Server2 

#>

    [CmdletBinding()]
    Param (
    [Parameter(Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Source Machine")]
    
    [String]$Reference,
    [Parameter(Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Target")]
    
    [String]$Target )
    
    $H1 = Get-Hotfix -ComputerName $Reference
    $H2 = Get-HotFix -ComputerName $Target

    $Results = Compare-Object $H1.HotFixID $H2.HotFixID
foreach ($item in $results)
{
$Nref = if ($Item.SideIndicator -eq "=>") {Write-Output "Not installed on: $Reference"} Elseif ($Item.SideIndicator -eq "<=") {Write-Output "Not installed on: $Target"}

$props = @{
                           
           Info =  $Nref; 
           HotFix = $Item.InputObject;
           SideIndicator = $Item.SideIndicator;
                           
                                                     
          }
                
                $obj = New-Object -TypeName PSObject -Property $props
                $obj.PSObject.TypeNames.Insert(0,'MOL')
                Write-Output $obj
                
     

}



}
Function Measure-LDAPRequestSpeed {

<#
.SYNOPSIS
JP's Measure-LDAPRequestSpeed Will tell you How long your DC(s) take to respond to LDAP Queries.
 
.DESCRIPTION
Measure How long your DC(s) take to respond to LDAP Queries

.EXAMPLE
Measure-LDAPRequestSpeed DomainControler1 Administrator

.EXAMPLE
Measure-LDAPRequestSpeed -DomainControler DomainControler1 -User Administrator

.EXAMPLE
Measure-LDAPRequestSpeed  DomainControler1 

This command will default to queiring Domaincontroler1 for the administrator account and report how long it takes.


#>

[CmdletBinding()]
param(
[Parameter(Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, HelpMessage="Enter DC names(s)")]
[String[]]$DomainController, 

[Parameter(Mandatory=$False, ValueFromPipeline=$True,  HelpMessage="Enter User name to Queiry")]
[String]$User = "Administrator"                       
)


Begin {
Try {import-Module ActiveDirectory}
Catch {Write-Output "Unable to load ActiveDirectory Module"}

}

PROCESS {
$ME = 10

Foreach ($DC in $DomainController)
{

#Initialise Values
$TotalM = 0
$i = 0

    While ($i -ne $ME)
    {
        $Measure = (Measure-Command {Get-ADUser -Identity $User -Server $DC}).TotalSeconds
        $Total += $Measure
        $i += 1
    } #While

      $totalM = $total / $ME

     Write-Output "$DC Response time: $totalM seconds"




}# Foreach


}#End Proccess



} # Function

Function Clone-GroupUsers {
<#
.SYNOPSIS
JP's Clone-UserGroups  copys the groups members  from one group  and moves them to another another use the replace switch to replace all permissions
 
.DESCRIPTION
copys the groups members  from one group  and moves them to another another use the replace switch to replace all permissions

.PARAMETER Source
The source User who groups are to be coppied 

.PARAMETER Destination
The Destination User to have groups added or replaced with the (-Replace) Switch

.EXAMPLE
Clone-GroupUsers -Source Group1 -Destination Group2

.EXAMPLE
Clone-GroupUsers Group1 Group2

.EXAMPLE
Clone-GroupUserss Group1 Group2 -replace




 #>
[CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact=’High’)]
        param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Enter the source User whos groups are to be coppied",
                   Position=0)]
        [string]$Source,
        [Parameter(Mandatory=$True,
                   HelpMessage="Enter the destination Computer for the Groups to be added to",
                   Position=1)]
        [string]$Destination,
        [Parameter(HelpMessage="Use -Replace to remove all permissions on Destination an replace with source"
       )]
        [switch]$Replace)

 BEGIN {
                Try {   Import-Module ActiveDirectory -ErrorAction Stop }
                Catch { Write-Host "Unable to load Actve Directory Powershell Module appears this feature is not availible on this machine" ; Break}
                }


PROCESS { $Users =  $(Get-ADGroup $Source -properties members).members | Get-ADUser

$Rem = $Users

            
                    IF ($replace) {
                                    $Dest =  $(Get-ADGroup $Destination -properties members).members | Get-ADUser
                                    
                                    foreach ($DE in $Dest) { Remove-ADGroupMember -identity $Destination -member $DE -Confirm:$false }
                                    
                                    foreach ($REM1 in $REM) 
                                    {
                                    Add-ADGroupMember -identity $Destination -members $REM1                                                                       
                                    }
                                    
                                    
                                    }

                    Else {foreach ($REM1 in $REM)  {Add-ADGroupMember -identity $Destination -members $REM1 } }
        }


}

Function Create-ADUsers {
#requires -Version 2


<#
.SYNOPSIS
JP's Create-ADUsers will create AD users in bulk from a CSV Note you need to include the following fileds:

Firstname | Surname | Username | OUPath 

OUPath = the destination distinguished path of the OU for the user(s)

The Follwoing Fields are optional:

Group1 | Group2 | Password | DisplayName | Description | Email | Initials | Department | Title | Company | City | telephoneNumber | PasswordNeverExpires
 
.DESCRIPTION
create AD users in bulk

.PARAMETER CSV
Provide Path to CSV file 

.EXAMPLE
Create-ADUsers -Path "C:\Scripts\csv.csv"
 #>

[CmdletBinding()]

param(
[parameter(Mandatory=$True, HelpMessage="Please provide path to CSV")]
[string]$CSV
)

$ProgressTitle = "Creating AD Users"

Import-Module ActiveDirectory

$CSV2 = Import-CSV $CSV

$DomainDetails = Get-ADdomain

Foreach ($item in $CSV2)
{

#Check if user Exists
Try
{$UserTest = Get-ADUser -identity $item.Username.trim()}
Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]{ 
Write-Output "User: $($item.Username.trim()) not found in AD Jtools will create the user"}

#Create user if it doesnt Exist
    If (!($UserTest))
    {
    #Create User
    New-ADUser $item.Username.trim()  -Path $item.OUPath.trim() -GivenName $item.FirstName.trim() -Surname $item.Surname.trim() -UserPrincipalName "$($item.Username.trim())@$($DomainDetails.DNSRoot)"
    $result += " $($item.UserName) |"
    Sleep -seconds 1
    }
    Else {
    $Name = $item.Users
    Write-Output "User: $($item.UserName) Already Exists Skipping..."

        Try{Clear-Variable -Name usertest}
        Catch [VariableNotFound,Microsoft.PowerShell.Commands.ClearVariableCommand]{Continue;}
    
    Continue;
    }



    #Check if user should should be added to group in Group1/2 field
    if ($item.Group1)
    {
    Add-ADGroupMember -identity $item.group1.trim() -Members $item.Username.trim()

    }

    if ($item.Group2)
    {
    Add-ADGroupMember -identity $item.group2.trim() -Members $item.Username.trim()
    }
   
    if ($item.Displayname)
    {
    Set-ADUser -identity $item.Username.trim() -DisplayName $item.Displayname.trim() -PassThru |`
    Rename-ADObject -NewName $item.Displayname.trim()
    }

    if($item.Description)
    {
    Set-Aduser -Identity $item.Username.trim() -Description $item.Description.trim()
    }

    if($item.Email)
    {
    Set-Aduser -Identity $item.Username.trim() -EmailAddress $item.Email.trim()
    }

    if($item.PasswordNeverExpires.tolower() -eq 'true')
    {
    Set-Aduser -Identity $item.Username.trim() -PasswordNeverExpires $True    
    }

    if ($item.Password)
    {
    #Change User Password
    Set-AdaccountPassword -Identity $item.Username.trim() -NewPassword  (ConvertTo-SecureString -AsPlainText $($item.Password) -Force)
    }

    if ($item.Initials)
    {
    #Add Initials    
    Set-Aduser -Identity $item.Username.trim() -Initials $item.Initials.trim()
    }

  if ($item.Department)
    {
    #Add Department    
    Set-Aduser -Identity $item.Username.trim() -Department $item.Department.trim()
    }


if ($item.Company)
    {
    #Add Company    
    Set-Aduser -Identity $item.Username.trim() -Company $item.Company.trim()
    }

if ($item.City)
    {
    #Add City    
    Set-Aduser -Identity $item.Username.trim() -City $item.City.trim()
    }

if ($item.telephoneNumber)
    {
    #Add telephoneNumber    
    Set-Aduser -Identity $item.Username.trim() -OfficePhone $item.telephoneNumber.trim()
    }
     if ($item.Password)
    {
    #Enable Account 
    Enable-ADAccount -identity $item.Username.trim()
    }
    


    #write progress
	$Counter++
    Try{
	Write-Progress -Activity $ProgressTitle -Status "Creating AD Accounts" -CurrentOperation $($item.Username) -PercentComplete ($counter / $($CSV2.Count) * 100)
    }Catch {Write-Output "."}
    
   
}

Write-Host "The Following Accounts have been created" -ForegroundColor DarkGreen
Write-Host "$result" -ForegroundColor DarkGreen


}

function Generate-LogEvent{
<#
.SYNOPSIS
JP's Generate-LogEvent will create a Log file named acording to what you want in CSV format:

It will look similar to this:
Object        | Message           | Severity | Date
mylogcreator    Created your file   Info       15/3/2017

This function always apends to the file specified.
 
.DESCRIPTION
create a Log file named acording to what you want in CSV format. This function always appends to the file specified

.PARAMETER Object
What is the name of of the object being loged

.PARAMETER Message
What message related to the loged event

.PARAMETER Severity
warning, info, Error

.EXAMPLE
 Generate-LogEvent -object 'Ftp transfer' -message 'completed no errors' -severity 'info' -logname 'C:\log\mylog.csv'
 #>
    param(
        [Parameter(Mandatory=$True, Position=0) ]
        [string]$object,
        [Parameter(Mandatory=$True, Position=1) ]
        [string]$message,
        [Parameter(Mandatory=$False) ]
        [string]$Severity, 
        [Parameter(Mandatory=$True) ]
        [string]$LogName 

    )

    $Log = New-Object PsObject
    $Log | Add-Member -Name "Object" -MemberType NoteProperty -Value $Null 
    $Log | Add-Member -Name "Message" -MemberType NoteProperty -Value $Null 
    $Log | Add-Member -Name "Date" -MemberType NoteProperty -Value $Null 
    $Log | Add-Member -Name "Severity" -MemberType NoteProperty -Value $Null 

        $Log.object = $object.trim()
        $Log.message = $message.trim()
        $Log.date = Get-date
        if ($message){$Log.severity = $Severity.trim()}
        else{ $Log.severity = 'info'}
        
        $Log | Export-Csv $LogName -Append
        

}

