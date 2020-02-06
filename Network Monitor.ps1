$compsList = Import-Csv $PSScriptRoot\devices.csv
if (!(Test-Path "$PSScriptRoot\logs\")){
    New-Item "$PSScriptRoot\logs\" -ItemType directory
}

$newline = $true
do {
$date = get-date -Format MM-dd-yy
foreach($device in $compsList)
{
    $test = Test-Connection -computername $device.Device -Quiet -Count 1
    $lineOutput = $device.Device + " " + $device.Name 
    if($newline -eq $true){
        $lineOutput = "`n" + $lineOutput
        $newline = $false
    }else{
        $lineOutput = ''.PadLeft(50-$lineCount) + $lineOutput
        $newline = $true
    }
    if($test){
        $lineOutput = $lineOutput + " " + "Success"
        $lineCount = $lineOutput.Length
        Write-Host $lineOutput -ForegroundColor "Blue" -NoNewline
    } else {
        add-content "$PSScriptRoot\logs\Failed$date.txt" -Value " FAILED $($device.Device) $($device.Name) $(get-date)"
        $value1 += "`n" + $device.Device + " " + $device.Name + " " + $device.Where + " FAILED"
        $lineOutput = $lineOutput + " " + $device.Where + " " + $device.SwitchName + " FAILED"
        $lineCount = $lineOutput.Length
        Write-host $lineOutput -fore Red -NoNewline
        [console]::beep(500,300)
        $serverDownNotify = $true
    }
    
}
Write-Output ""
$saveY = [console]::CursorTop
$saveX = [console]::CursorLeft

If($serverDownNotify -eq $true){
    
    
    $body = @{value1 = $value1}
    $uri = "http://your.webhook.here"
    $null = Invoke-RestMethod -Method Get -Uri $Uri -Body $body
}

for ($a=0; $a -le 20; $a++){
    start-sleep 1
    [console]::setcursorposition($saveX,$saveY)
    Write-Host "Waiting" (20-$a) "seconds... "
}
$value1 = ""
$serverDownNotify = $false
Clear
}while ($true)
