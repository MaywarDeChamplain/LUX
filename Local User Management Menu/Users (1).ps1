

<# ******************************
# Create a function that returns a list of NAMEs AND SIDs only for enabled users
****************************** #>
function getEnabledUsers(){

  $enabledUsers = Get-LocalUser | Where-Object { $_.Enabled -ilike "True" } | Select-Object Name, SID
  return $enabledUsers

}



<# ******************************
# Create a function that returns a list of NAMEs AND SIDs only for not enabled users
****************************** #>
function getNotEnabledUsers(){

  $notEnabledUsers = Get-LocalUser | Where-Object { $_.Enabled -ilike "False" } | Select-Object Name, SID
  return $notEnabledUsers

}




<# ******************************
# Create a function that adds a user
****************************** #>
function createAUser($name, $password) 
{
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
    $params = @{
        Name = $name
        Password = $securePassword
    }

    $newUser = New-LocalUser @params
    Set-LocalUser $newUser -PasswordNeverExpires $false
    Disable-LocalUser $newUser
}




function removeAUser($name) 
{
    $userToBeDeleted = Get-LocalUser | Where-Object { $_.Name -ilike $name }
    if ($userToBeDeleted) 
    {
        Remove-LocalUser $userToBeDeleted
    } else {
        Write-Host "User not found."
    }
}




function disableAUser($name){
   
   $userToBeDeleted = Get-LocalUser | Where-Object { $_.name -ilike $name }
   Disable-LocalUser $userToBeDeleted
   
}


function enableAUser($name){
   
   $userToBeEnabled = Get-LocalUser | Where-Object { $_.name -ilike $name }
   Enable-LocalUser $userToBeEnabled
   
}

function checkUser($name)
{
    $userExists = Get-LocalUser | Where-Object { $_.Name -eq $name}

    return $userExists -ne $null
}

function checkPassword($password)
{
    $basePassword = $password

    if ($basePassword.Length -lt 6)
    {
        return $false
    }
    
    elseif (-not ($basePassword -match '[A-Za-z]'))
    {
        return $false
    }

    elseif (-not ($basePassword -match '[0-9]'))
    {
        return $false
    }

    elseif (-not ($basePassword -match '[^A-Za-z0-9]'))
    {
        return $false
    }
    
    else
    {
        return $true
    }
}

function getAtRiskUsers($days)
{
    $failedLogins = getFailedLogins $days
    $riskUsers = $failedLogins | Group-Object User | Where-Object { $_.Count -gt 10 } | Select-Object Name, Count

    return $riskUsers
}
