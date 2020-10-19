# in order to use SSH you will first need install Posh-SSH
# More info here https://www.powershellgallery.com/packages/Posh-SSH

# imports a csv file with fist column labled Device and second labled Name
$deviceList = Import-Csv $PSScriptRoot\devices.csv

# sets the extension of the filename
$ext =".txt"

# file path where the file will be saved
$filepath ="\\usblns-file2\Scripts\Network Tools\ssh ssl\logs\"

# Gets Credentials for Switch
#$creds = Get-Credential


# these are the command to be run, it is set to show running configuration so we can get the running config
$c1 = "terminal length 0"
$c2 = "sh run"
$c3 = "terminal length 24"

# gets the date and creates a folder with that name
$date = Get-Date -Format "MM-dd-yyyy HH.mm"
New-Item -Path $filepath -Name $date -ItemType "directory"


# this makes a loop for each line that was imported from the csv file 
foreach($device in $deviceList)
{
       
    # This opens a new SSH session with a device from the devices csv file
    $session = New-SSHSession -ComputerName $device.Device -Credential $cred –AcceptKey
    $SSHStream = New-SSHShellStream -Index $session.SessionId

    # This runs our ssh command and puts it into a varible called $Results
    $SSHStream.WriteLine($c1)
    sleep 1
    $SSHStream.WriteLine($c2)
    sleep 1
    $SSHStream.WriteLine($c3)
    sleep 1



    # This takes the device name from the csv file and puts it into a varible so we can save the name of file as the device name
    $filename = $device.Name

    # This creates/overwrites a file within our filepath and in the folder we created with the date. 
    # The name of which is the device name from the csv file. 
    # The file will be fuled with the output of $results
    $results = $sshstream.read() 
    sleep 1

    Set-Content $filepath$date\$filename$ext $results
    

    # This closes the SSH session
    Remove-SSHSession -SSHSession $session 

}




 
