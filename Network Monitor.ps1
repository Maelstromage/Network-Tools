$compsList = Import-Csv $PSScriptRoot\devices.csv



do {
foreach($device in $compsList)
{
    $test = Test-Connection -computername $device.Device -Quiet -Count 1
    if($test){
        Write-Host $device.Device $device.Name "Success" -ForegroundColor "Blue"
    } else {
        Write-host $device.Device $device.Name $device.Where "FAILED" -fore Red
        [console]::beep(500,300)
    }
    
}
for ($a=0; $a -le 20; $a++){
    start-sleep 1
    $b=$a*5
    Write-Progress -activity "Waiting..." -status "$b%" -PercentComplete $b;
}
Clear
Write-Host "`n`n`n`n`n`n`n`n`n`n`n`n"
}while ($true)

