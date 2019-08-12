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
Start-Sleep 1
}while ($true)
