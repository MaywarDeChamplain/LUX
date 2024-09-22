
Function GetLogInOut($days){
$loginouts = Get-EventLog system -Source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-$days)

$loginoutsTable = @()

for ($i = 0; $i -lt $loginouts.Count; $i++) {
    $event = ""
    if ($loginouts[$i].InstanceID -eq 7001) { $event = "Logon" }
    if ($loginouts[$i].InstanceID -eq 7002) { $event = "Logoff" }

    $userSID = $loginouts[$i].ReplacementStrings[1]

    $objSID = New-Object System.Security.Principal.SecurityIdentifier($userSID)
    $username = $objSID.Translate([System.Security.Principal.NTAccount]).Value


    $loginoutsTable += [PSCustomObject]@{"Time" = $loginouts[$i].TimeGenerated
        "Id" = $loginouts[$i].InstanceId
        "Event" = $event
        "User" = $username
    }
}
    return $loginoutsTable
}


Function GetShutDown($days){
$shutDowns = Get-EventLog -LogName system -Source user32 -After (Get-Date).AddDays(-$days)

$shutDownsTable = @()

#no code for the startup or shutdown appeared but other code did
#thought mabey it was because I never shut off my vm or something
for($i = 0; $i -lt $shutDowns.Count; $i++){
    $event = ""
    if ($shutDowns[$i].EventId -eq 6006) { $event = "Shutdown"}
    if ($shutDowns[$i].EventId -eq 6005) { $event = "Startup"}
     if ($shutDowns[$i].EventId -eq 6008) { $event = "UnexspectedShutdown"}
    if ($shutDowns[$i].EventId -eq 1074) { $event = "RestartorShutdown"}

    $shutDownsTable += [PSCustomObject]@{"Time" = $shutDowns[$i].TimeGenerated
        "Id" = $shutDowns[$i].EventId
        "Event" = $event
        "User" = "System"
    }
    }

return $shutDownsTable
}


#testing
#$inputDays = Read-Host "input the days"
#GetShutDown($inputDays)
