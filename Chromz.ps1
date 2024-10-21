function openChrome()
{
    $chrome = Get-Process chrome -ErrorAction SilentlyContinue
    if ($chrome)
    {
        Stop-Process -Name "chrome" -Force
    }
    else
    {
        Start-Process $chrome "https://champlain.edu"
    }
}
