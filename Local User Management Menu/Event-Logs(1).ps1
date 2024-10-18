. "$PSScriptRoot\String-Helper(1).ps1"


<# ******************************
     Function Explaination
****************************** #>
function getLogInAndOffs($timeBack) 
{
    $loginouts = Get-EventLog system -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays("-$timeBack")

    $loginoutsTable = @()
    for($i = 0; $i -lt $loginouts.Count; $i++) 
    {
        $type = ""
        if ($loginouts[$i].InstanceID -eq 7001) { $type = "Logon" }
        if ($loginouts[$i].InstanceID -eq 7002) { $type = "Logoff" }

        try 
        {
            $user = (New-Object System.Security.Principal.SecurityIdentifier `
                     $loginouts[$i].ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])
        } catch 
        {
            $user = "Unknown User"
        }

        $loginoutsTable += [pscustomobject]@{
            "Time"  = $loginouts[$i].TimeGenerated
            "Id"    = $loginouts[$i].InstanceId
            "Event" = $type
            "User"  = $user
        }
    }

    return $loginoutsTable
}





<# ******************************
     Function Explaination
****************************** #>
function getFailedLogins($timeBack) {
    $failedlogins = Get-EventLog security -After (Get-Date).AddDays("-$timeBack") | Where-Object { $_.InstanceID -eq 4625 }

    $failedloginsTable = @()
    for($i = 0; $i -lt $failedlogins.Count; $i++) 
    {
        $usr = "Unknown"
        $dmn = "Unknown"

        $usrlines = getMatchingLines $failedlogins[$i].Message "*Account Name*"
        if ($usrlines.Count -gt 1) 
        {
            $usr = $usrlines[1].Split(":")[1].Trim()
        }

        # Extract Account Domain
        $dmnlines = getMatchingLines $failedlogins[$i].Message "*Account Domain*"
        if ($dmnlines.Count -gt 1) 
        {
            $dmn = $dmnlines[1].Split(":")[1].Trim()
        }

        $user = "$dmn\$usr"

        $failedloginsTable += [pscustomobject]@{
            "Time"  = $failedlogins[$i].TimeGenerated
            "Id"    = $failedlogins[$i].InstanceId
            "Event" = "Failed"
            "User"  = $user
        }
    }

    return $failedloginsTable
}
