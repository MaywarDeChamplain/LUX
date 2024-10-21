function readConfiguration()
{
    $configurationFile = ("$PSScriptRoot\configuration.txt")
    $configurationFile = Get-Content $configurationFile

    $results = @()

    $days = $configurationFile[0]
    $executionTime = $configurationFile[1]

    $results += [pscustomobject]@{"Days" = $days; `
                                  "ExecutionTime" = $executionTime;
    }

    $results
}

function changeConfiguration()
{
    Write-Host "Enter new number of days:"
    $days = Read-Host

    Write-Host "Enter new execution time:"
    $executionTime = Read-Host

    $days + "`n" + $executionTime | Out-File $PSScriptRoot/"configuration.txt"
}


function configurationMenu()
{
    $operation = $true


    $prompt = "`n"
    $prompt += "Please choose your operation:`n"
    $prompt += "1 - Show Configuration`n"
    $prompt += "2 - Change Configuration`n"
    $prompt += "3 - Exit"

    while($operation)
    {
        Write-Host $prompt | Out-String
        $choice = Read-Host

        if ($choice -eq 1)
        {
            readConfiguration
        }

        elseif ($choice -eq 2)
        {
            changeConfiguration
        }

        elseif ($choice -eq 3)
        {
            Write-Host "Exiting program!" | Out-String

            $operation = $false
        }

        else
        {
            Write-Host "Bad input. Please enter a digit between 1-3" | Out-String
        }

    }
}

configurationMenu
