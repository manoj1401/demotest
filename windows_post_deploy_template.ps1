Get-LocalGroupMember -Group "Remote Desktop Users" | ForEach-Object {Remove-LocalGroupMember -Group "Remote Desktop Users" -Member $_ -Confirm:$false}
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "${secondDomainLevel}\${projectADgroup}"
Remove-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Remove-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
$disks = Get-Disk | Where partitionstyle -eq 'raw' | sort number

$letters = 70..89 | ForEach-Object { [char]$_ }
$count = 0
$labels = "data1","data2"

foreach ($disk in $disks) {
    $driveLetter = $letters[$count].ToString()
    $disk |
    Initialize-Disk -PartitionStyle MBR -PassThru |
    New-Partition -UseMaximumSize -DriveLetter $driveLetter |
    Format-Volume -FileSystem NTFS -NewFileSystemLabel $labels[$count] -Confirm:$false -Force
    $count++
}
function Install-Sharing() {
 $folderPath = 'F:\\ProjectShare';
 if(!(Test-Path $folderPath)) {
 New-Item -Path 'F:\\' -Name 'ProjectShare' -ItemType 'directory';
 New-SmbShare -Name 'ProjectShare' -Path 'F:\ProjectShare';
 Grant-SmbShareAccess -Name 'ProjectShare' -AccountName 'BUILTIN\Users' -AccessRight Change -Force;
 $permission3 = 'BUILTIN\Users', 'Read, Write', 'ContainerInherit, ObjectInherit', 'None', 'Allow';
 $acl = Get-Acl $folderPath;
 $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permission3;
 $acl.SetAccessRule($AccessRule);
 $acl | Set-Acl $folderPath;
 }
 
};
 
Install-Sharing;
function Install-Sharing() {
 $folderPath = 'F:\\SoftwareShare';
 if(!(Test-Path $folderPath)) {
 New-Item -Path 'F:\\' -Name 'SoftwareShare' -ItemType 'directory';
 New-SmbShare -Name 'SoftwareShare' -Path 'F:\SoftwareShare';
 Grant-SmbShareAccess -Name 'ProjectShare' -AccountName 'BUILTIN\Users' -AccessRight Change -Force;
 $permission3 = 'BUILTIN\Users', 'Read, Write', 'ContainerInherit, ObjectInherit', 'None', 'Allow';
 $acl = Get-Acl $folderPath;
 $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permission3;
 $acl.SetAccessRule($AccessRule);
 $acl | Set-Acl $folderPath;
 }
 
};
 
Install-Sharing;