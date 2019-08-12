# imports a csv file with fist column labled Device and second labled Name
$deviceList = Import-Csv $PSScriptRoot\devices.csv

# sets the extension of the filename
$ext =".txt"

# file path where the file will be saved
$filepath =""

# username to log into the switches
$u1 =""

# asks for the password and makes it a secure string 
$p1 = read-host -Prompt "please input password" -AsSecureString

# this is the command to be run, it is set to show running configuration so we can get the running config
$c1 ="sh run"

# gets the date and creates a folder with that name
$date = Get-Date -Format "MM-dd-yyyy HH.mm"
New-Item -Path $filepath -Name $date -ItemType "directory"


# this makes a loop for each line that was imported from the csv file 
foreach($device in $deviceList)
{
       
    # This opens a new SSH session with a device from the devices csv file
    New-SshSession $device.Device -Username $u1 -Password ([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($p1)))

    # This runs our ssh command and puts it into a varible called $Results
    $Results = Invoke-Sshcommand -Verbose -InvokeOnAll -Command "$c1"

    # This takes the device name from the csv file and puts it into a varible so we can save the name of file as the device name
    $filename = $device.Name

    # This creates/overwrites a file within our filepath and in the folder we created with the date. 
    # The name of which is the device name from the csv file. 
    # The file will be fuled with the output of $results
    Set-Content $filepath$date\$filename$ext $Results.Result

    # This closes the SSH session
    Remove-SshSession -RemoveAll

}
