$compsList = Import-Csv $PSScriptRoot\devices.csv
if (!(Test-Path "$PSScriptRoot\logs\")){
    New-Item "$PSScriptRoot\logs\" -ItemType directory
}

do {
$date = get-date -Format MM-dd-yy
foreach($device in $compsList)
{
    $test = Test-Connection -computername $device.Device -Quiet -Count 1
    if($test){
        add-content "$PSScriptRoot\logs\Success$date.txt" -Value "$($device.Device) $($device.Name) Success $(get-date)"
        Write-Host $device.Device $device.Name "Success" -ForegroundColor "Blue"
    } else {
        add-content "$PSScriptRoot\logs\Failed$date.txt" -Value " FAILED $($device.Device) $($device.Name) $(get-date)"
        Write-host $device.Device $device.Name $device.Where "FAILED" -fore Red
        [console]::beep(500,300)
    }
    
}

$saveY = [console]::CursorTop
$saveX = [console]::CursorLeft
for ($a=0; $a -le 20; $a++){
    start-sleep 1
    
    #Write-Progress -activity "Waiting..." -status "$b%" -PercentComplete $b;
    [console]::setcursorposition($saveX,$saveY)
    Write-Host "Waiting" (20-$a) "seconds... "
}
Clear
}while ($true)
