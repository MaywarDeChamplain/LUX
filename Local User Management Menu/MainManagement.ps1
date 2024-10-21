. "$PSScriptRoot\Users.ps1"
. "$PSScriptRoot\EventLogs.ps1"

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - List at Risk Users`n"
$Prompt += "10 - Exit`n"



$operation = $true

while($operation){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 10){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }

    elseif($choice -eq 1){
        $enabledUsers = getEnabledUsers
        Write-Host ($enabledUsers | Format-Table | Out-String)
    }

    elseif($choice -eq 2){
        $notEnabledUsers = getNotEnabledUsers
        Write-Host ($notEnabledUsers | Format-Table | Out-String)
    }

    elseif($choice -eq 3){ 

        $name = Read-Host -Prompt "Please enter the username for the new user"
        $password = Read-Host -AsSecureString -Prompt "Please enter the password for the new user"

        if (-not $userCheck)
        {
            if (checkPassword $password)
            {
                createAUser $name $password

                Write-Host "User: $name is created." | Out-String
            }

            else
            {
                Write-Host "Password does not satisfy needed conditions." | Out-String
            }
        }

        else
        {
            Write-Host "User: $name already exists." | Out-String
        }
    }


    elseif($choice -eq 4){

        $name = Read-Host -Prompt "Please enter the username for the user to be removed"

        removeAUser $name

        if (checkUser $name)
        {
            removeAuser $name
            Write-Host "User: $name Removed." | Out-String
        }

        else
        {
            Write-Host "User: $name does not exist" | Out-String
        }
    }


    elseif($choice -eq 5){


        $name = Read-Host -Prompt "Please enter the username for the user to be enabled"

        if (checkUser $name)
        {
            enableAUser $name

            Write-Host "User: $name Enabled." | Out-String
        }

        else
        {
            Write-Host "User: $name does not exist" | Out-String
        }
    }


    elseif($choice -eq 6){

        $name = Read-Host -Prompt "Please enter the username for the user to be disabled"

        if (checkUser $name)
        {
            disableAUser $name

            Write-Host "User: $name Disabled." | Out-String
        }

        else
        {
           Write-Host "User: $name does not exist" | Out-String
        }
    }


    elseif($choice -eq 7){

        $name = Read-Host -Prompt "Please enter the username for the user logs"

        if (checkUser $name)
        {
            $days = Read-Host -Prompt "Please enter the number of days to get logs for"
            $userLogins = getLogInAndOffs $days

            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)

        }
        
        else
        {
            Write-Host "User: $name does not exist" | Out-String
        }
    }


    elseif($choice -eq 8){

        $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"

        if(checkUser $name)
        {

            $days = Read-Host -Prompt "Please enter the number of days to get logs for"
            $userLogins = getFailedLogins $days

            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
        }

        else
        {
            Write-Host "User: $name does not exist" | Out-String
        }
    }

    elseif($choice -eq 9)
    {
        $days = Read-Host -Prompt "Enter the number of days to list at risk users for"
        $riskUsers = getAtRiskUsers $days

        Write-Host ($riskUsers | Format-Table | Out-String)
    }

    else
    {
       Write-Host "Invalid option. Enter a digit between 1-9" | Out-String
    }
}
