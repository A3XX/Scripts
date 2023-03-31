$computers = Get-ADComputer -Filter {Enabled -eq $true} | Select-Object -ExpandProperty Name

foreach ($computer in $computers) {
    if (Test-WSMan -ComputerName $computer -ErrorAction SilentlyContinue) {
        $service = Get-Service -ComputerName $computer -Name "sensu"
        if ($service.Status -eq "Running") {
            Write-Host "The Sensu service is running on $computer."
        } else {
            Write-Host "The Sensu service is not running on $computer."
        }
    } else {
        Write-Host "Could not connect to $computer."
    }
}
