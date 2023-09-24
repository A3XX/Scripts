# Technical Document: Building a Windows Server 2019 Domain Controller for nyc.muzamal.com Domain

**Document Version**: 1.0
**Last Updated**: September 24, 2023

## Table of Contents
1. Introduction
2. Prerequisites
3. Install Windows Server 2019
4. Configure Static IP Address
5. Install Active Directory Domain Services (AD DS)
6. Promote the Server to a Domain Controller
7. Verify Domain Controller Synchronization
8. Check and Migrate FSMO Roles
9. Update DNS Records on Active and Pingable Computers
10. Conclusion

## 1. Introduction

This document provides step-by-step instructions on how to build a new Windows Server 2019 Domain Controller for the nyc.muzamal.com domain. It also includes steps to verify domain controller synchronization, check and migrate Flexible Single Master Operations (FSMO) roles, and provides a PowerShell script to update DNS records on all active and pingable computers in the domain.

## 2. Prerequisites

Before proceeding, ensure you have the following:

- A Windows Server 2019 installation media.
- A server with appropriate hardware specifications.
- Administrative credentials for the server.
- A network connection with a static IP address.
- Access to DNS records for the nyc.muzamal.com domain.

## 3. Install Windows Server 2019

1. Boot the server from the Windows Server 2019 installation media.
2. Follow the on-screen instructions to install Windows Server 2019.
3. Choose the option for a clean installation.
4. Set a strong password for the Administrator account during installation.

## 4. Configure Static IP Address

1. After installation, log in to the server using the Administrator account.
2. Open "Control Panel" > "Network and Sharing Center."
3. Click on the network connection, then click "Properties."
4. Select "Internet Protocol Version 4 (TCP/IPv4)" and click "Properties."
5. Enter the server's static IP address, subnet mask, default gateway, and DNS server addresses.

## 5. Install Active Directory Domain Services (AD DS)

1. Open "Server Manager."
2. Click on "Manage" in the upper-right corner and select "Add Roles and Features."
3. Follow the wizard, selecting "Active Directory Domain Services" for installation.
4. Complete the installation with default settings.

## 6. Promote the Server to a Domain Controller

1. After installing AD DS, open "Server Manager."
2. Click on the notification flag and select "Promote this server to a domain controller."
3. Choose "Add a new forest" and enter the root domain name, e.g., "nyc.muzamal.com."
4. Set the Directory Services Restore Mode (DSRM) password.
5. Review and confirm the settings, then proceed with the installation.
6. The server will automatically restart as a domain controller.

## 7. Verify Domain Controller Synchronization

To check if the domain controller is synchronized correctly, follow these steps:

1. Log in to the domain controller.
2. Open PowerShell with administrative privileges.
3. Run the following command to check the replication status:
   ```
   Get-ADReplicationPartnerMetadata -Target * | Select-Object Server,LastReplicationSuccess
   ```
   This command should show information about replication partners and the last successful replication.

## 8. Check and Migrate FSMO Roles

To check and migrate FSMO roles, follow these steps:

1. Open PowerShell with administrative privileges on the new domain controller.
2. Run the following command to check the current FSMO role holders:
   ```
   Get-ADForest | Format-Table DomainNamingMaster, SchemaMaster
   Get-ADDomain | Format-Table InfrastructureMaster, PDCEmulator, RIDMaster
   ```
3. If needed, transfer the FSMO roles using PowerShell:
   - To transfer the Schema Master role:
     ```
     Move-ADDirectoryServerOperationMasterRole -Identity "NewDC" -OperationMasterRole SchemaMaster
     ```
   - Repeat this command for other roles as needed, replacing the `-OperationMasterRole` parameter with the appropriate role.

## 9. PowerShell Script to Update DNS Records

Below is a PowerShell script to update DNS records on all active and pingable computers in the domain:

```powershell
# Define the DNS server IP address
$DNSServer = "Your_DNS_Server_IP_Address"

# Get a list of all computers in the domain
$Computers = Get-ADComputer -Filter *

# Loop through each computer and update DNS settings
foreach ($Computer in $Computers) {
    $ComputerName = $Computer.Name
    Write-Host "Updating DNS for $ComputerName"
    
    # Set DNS server settings
    Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses $DNSServer
    
    # Flush DNS cache
    ipconfig /flushdns
    
    # Ping the computer to refresh DNS
    Test-Connection -ComputerName $ComputerName -Count 1
    
    Write-Host "DNS updated for $ComputerName"
}

Write-Host "DNS update complete for all active and pingable computers."
```

Replace `"Your_DNS_Server_IP_Address"` with the IP address of your DNS server.

## 10. Conclusion

You have successfully built a new Windows Server 2019 Domain Controller for the nyc.muzamal.com domain. Ensure that you regularly monitor and maintain your domain controller to keep it secure and up-to-date. Additionally, use the provided PowerShell script to update DNS records on active computers as needed.