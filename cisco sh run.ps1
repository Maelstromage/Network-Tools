$deviceList = Import-Csv $PSScriptRoot\devices.csv
$filename ="config"
$ext =".txt"
$filepath =""
$u1 ="" #username
$p1 = read-host -Prompt "please input password" -AsSecureString
$c1 ="sh run"
$date = Get-Date -Format "MM-dd-yyyy HH.mm"
New-Item -Path $filepath -Name $date -ItemType "directory"



foreach($device in $deviceList)
{
   
    New-SshSession $device.Device -Username $u1 -Password ([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($p1)))
    $Results = Invoke-Sshcommand -Verbose -InvokeOnAll -Command "$c1"
    $filename = $device.Name
    Set-Content $filepath$date\$filename$ext $Results.Result
    Remove-SshSession -RemoveAll

}
