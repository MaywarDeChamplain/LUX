. "$PSScriptRoot\Scheduler.ps1"
. "$PSScriptRoot\Users.ps1"
. "$PSScriptRoot\Configuration.ps1"
. "$PSScriptRoot\Email.ps1"
. "$PSScriptRoot\EventLogs.ps1"

$configuration = readConfiguration
$Failed = getAtRiskUsers $configuration.Days
SendAlertEmail ($failed | Format-Table | Out-String)
ChooseTimeToRun($configuration.ExecutionTime)