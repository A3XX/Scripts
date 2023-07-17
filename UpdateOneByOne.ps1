function Write-Log 
{
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    $LogFile = "C:\Logs\UpdateScriptlog.txt"
    # Get the current timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss tt"
    # Format the log entry
    $logEntry = "{0} - {1}" -f $timestamp, $Message
    # Append the log entry to the log file
    $logEntry | Out-File -FilePath $LogFile -Append
}

try
{

$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateupdateSearcher()
$UpdateSearchResults = $UpdateSearcher.Search("IsHidden=0 and IsInstalled=0")
$Updates = $UpdateSearchResults.Updates

if ($null -ne $Updates -and $Updates.Count -eq 0 )
{
     Write-Output "No new update available.Exiting now."
     Write-Log -Message "No new update available.Exiting now."
     return
}

if ($null -ne $Updates -and $Updates.Count -gt 0 )
{

    Write-Output "$($Updates.Count) new available update will get installed."
    Write-Log -Message "$($Updates.Count) new available update will get installed."

   
   foreach($update in $Updates)
    {
        ##$FilteredUpdates =  $Updates | Where-Object { $_ -eq $update }

        $CurrUpdates =  New-Object -ComObject Microsoft.Update.UpdateColl
        $CurrUpdates.Add($update) 

         Write-Output "Downloading Update:$($update.Title)"
         Write-Log -Message "Downloading Update:$($update.Title)"
        # Download the update
        $downloader = $UpdateSession.CreateUpdateDownloader()
        
        $downloader.Updates = $CurrUpdates
        
        $downloadResult = $downloader.Download()

        # If the download is successful, install the update
        if ($downloadResult.ResultCode -eq 2)
        {
            
            Write-Output "Installing Update:$($update.Title)"
            Write-Log -Message "Installing Update:$($update.Title)"
            
            $installer = $UpdateSession.CreateUpdateInstaller()

            $installer.Updates = $CurrUpdates
            
            $installResult = $installer.Install()

            # If the installation is successful, output a message
            if ($installResult.ResultCode -eq 2)
            {
                Write-Output "Update $($update.Title) installed successfully."
                Write-Log -Message  "Update $($update.Title) installed successfully."

                # Check if a reboot is required
                if ($installResult.RebootRequired)
                {
                    Write-Output "A reboot is required to complete the installation of $($update.Title)."
                    Write-Log -Message  "A reboot is required to complete the installation of $($update.Title)."
                    Restart-Computer -Force
                }
            }
            else
            {
                Write-Warning "Update $($update.Title) failed to install."
                Write-Log -Message  "Update $($update.Title) failed to install."
            }
        }
        else
        {
            Write-Warning "Update $($update.Title) failed to download."
            Write-Log -Message "Update $($update.Title) failed to download."
        }
    }
    

}

}
Catch [System.Exception]
{
         
         $messageError = "Error encountered:"+ $($_.Exception.Message)
         Write-Log -Message $messageError
         Write-Host ($messageError) -ForegroundColor Red             
}


