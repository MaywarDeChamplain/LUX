function SendAlertEmail($Body)
{
    $From = "noah.maywar@mymail.champlain.edu"
    $To = "noah.maywar@mymail.champlain.edu"
    $Subject = "Awesome Activity"

    $Password = "dmex gqwp qapp kvzg" | ConvertTo-SecureString -AsPlainText -Force
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password

    Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer "smtp.gmail.com" -port 587 -UseSsl -Credential $Credential
}

SendAlertEmail "Body of email"