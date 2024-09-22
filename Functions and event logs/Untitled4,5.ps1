. ($PSScriptRoot + "\Untitled3.ps1")

$loginouts = GetLogInOut(10)
$shutdowns = GetShutDown(10)

Write-Host "Seperater-----"
$loginouts | Format-Table
Write-Host "Seperater-----"
$shutdowns | Format-Table

$loginouts = GetLogInOut(25)
$shutdowns = GetShutDown(25)

Write-Host "Seperater-----"
$loginouts | Format-Table
Write-Host "Seperater-----"
$shutdowns | Format-Table

$loginouts = GetLogInOut(30)
$shutdowns = GetShutDown(30)

Write-Host "Seperater-----"
$loginouts | Format-Table
Write-Host "Seperater-----"
$shutdowns | Format-Table
