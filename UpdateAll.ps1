$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateupdateSearcher()
$UpdateSearchResults = $UpdateSearcher.Search("IsHidden=0 and IsInstalled=0")
$Updates = $UpdateSearchResults.Updates

if ($null -ne $Updates -and $Updates.Count -eq 0 )
{
     Write-Output "No new update available.Exiting now."
     return
}

if ($null -ne $Updates -and $Updates.Count -gt 0 )
{

    Write-Output "$($Updates.Count) new available update will get installed."

    Write-Output "Downloading Updates..."
    # Download updates
    $downloader = $UpdateSession.CreateUpdateDownloader()
    $downloader.Updates = $Updates
    $downloadResult = $downloader.Download()

    if ($downloadResult.ResultCode -eq 2)
    {
         Write-Output "Installing Updates..."
         # Install updates
        $installer = $UpdateSession.CreateUpdateInstaller()
        $installer.Updates = $Updates
        $installResult = $installer.Install()

        if ($installResult.ResultCode -eq 2)
         {
             Write-Output "Updates installed successfully."
         }
         else
         {
          Write-Output "Updates installation was un-successfull."
         }

        if ($installResult.RebootRequired)
        {
            Write-Output "Updates require reboots.Rebooting now..."
            Restart-Computer -Force
        }
    }

}