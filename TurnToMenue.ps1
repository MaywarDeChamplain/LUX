. "$PSScriptRoot\ApacheLogsps1.ps1"
. "$PSScriptRoot\EventLogs.ps1"
. "$PSScriptRoot\Chromz.ps1"
. "$PSScriptRoot\Users.ps1"


$operation = $true

$prompt = "`n"
$prompt += "Please choose your operation:`n"
$prompt += "1 - Display Last 10 Apache Logs`n"
$prompt += "2 - Display Last 10 Failed Logins`n"
$prompt += "3 - Display at Risk Users`n"
$prompt += "4 - Start Chrome`n"
$prompt += "5 - Exit"

while ($operation)
{
    $prompt
    $choice = Read-Host

    if ($choice -eq 1)
    {
        $apacheLogs = ApacheLogs1 | Select-Object -Last 10

        $apacheLogs
    }

    elseif ($choice -eq 2)
    {
        getFailedLogins 10
    }

    elseif ($choice -eq 3)
    {
        $days = Read-Host -Prompt "Enter the number of days to list at risk users for"
        $riskUsers = getAtRiskUsers $days

        Write-Host ($riskUsers | Format-Table | Out-String)
    }

    elseif ($choice -eq 4)
    {
        openChrome
    }

    elseif ($choice -eq 5)
    {
        Write-Host "Exiting program!" | Out-String
        $operation = $false
    }

    else
    {
        Write-Host "Please enter a valid option (digit between 1 and 5)!" | Out-String
    }
}