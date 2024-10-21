
function getEnabledUsers(){

  $enabledUsers = Get-LocalUser | Where-Object { $_.Enabled -ilike "True" } | Select-Object Name, SID
  return $enabledUsers

}

function getNotEnabledUsers(){

  $notEnabledUsers = Get-LocalUser | Where-Object { $_.Enabled -ilike "False" } | Select-Object Name, SID
  return $notEnabledUsers

}

function createAUser($name, $password){

   $params = @{
     Name = $name
     Password = $password
   }

   $newUser = New-LocalUser @params 

   Set-LocalUser $newUser -PasswordNeverExpires $false

   Disable-LocalUser $newUser

}

function removeAUser($name){
   
   $userToBeDeleted = Get-LocalUser | Where-Object { $_.name -ilike $name }
   Remove-LocalUser $userToBeDeleted
   
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
    $basePassword = [System.Runtime.Interop.Services.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($password))

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