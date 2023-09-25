Demoting a Domain Controller (DC) involves removing its Active Directory Domain Services (AD DS) role from the server. This process is known as "demotion." Here's how to demote a Windows Server DC:

**Note:** Before proceeding, ensure that you have a valid reason to demote the DC and that it is not the last DC in the domain, as that would cause issues with Active Directory. Additionally, make sure you have adequate backups and are logged in with an account that has appropriate permissions.

1. **Log in to the DC:**
   Log in to the Domain Controller you want to demote using an account with Domain Admin or Enterprise Admin privileges.

2. **Open Server Manager:**
   Open "Server Manager" by clicking on the "Server Manager" icon in the taskbar or by searching for it in the Start menu.

3. **Remove Roles and Features:**

   a. In Server Manager, click on "Manage" in the top-right corner.

   b. Select "Remove Roles and Features" from the dropdown.

4. **Before You Begin:**

   Click "Next" on the "Before You Begin" screen.

5. **Select Destination Server:**

   Ensure the server you want to demote is selected and click "Next."

6. **Remove Server Roles:**

   Uncheck the "Active Directory Domain Services" checkbox in the "Remove Roles" screen. This will prompt a pop-up message informing you that removing the AD DS role will also remove DNS unless it's being used by other applications. Click "Remove Features" in the pop-up.

7. **Remove Features:**

   a. Click "Next" on the "Features" screen.

   b. Review the information on the "AD DS" screen and click "Next."

   c. You will see a warning that DNS is a required feature for AD DS. If you don't have another DNS server in the domain, you should consider installing DNS on another server before demoting this DC. Click "Remove" to proceed.

8. **Active Directory Domain Services:**

   Review the information in the "AD DS" screen, and click "Next."

9. **Confirmation:**

   Review the summary of the changes you're about to make. Ensure that the "Remove DNS Server" option is checked if you want to remove DNS as well. Click "Demote."

10. **Demotion Options:**

    a. Select the demotion option based on your needs:
       - "Retain this server in the domain as a member server": This option retains the server as a member server in the domain without AD DS.
       - "Force the removal of this domain controller": Use this option if the DC is not communicative with other DCs in the domain.
   
    b. Enter the Directory Services Restore Mode (DSRM) password, which you set during the DC promotion process.

    c. Click "Next."

11. **Warning:**

    Read the warning message about the implications of demoting a DC. Confirm that you have appropriate backups and that you understand the consequences. Click "Next."

12. **Uninstall:**

    The demotion process will begin. It will remove the AD DS role and DNS (if selected) from the server. This may take some time.

13. **Completion:**

    Once the process is complete, review the completion screen for any warnings or errors. If everything went well, you should see a "Demotion was successful" message.

14. **Reboot:**

    It's a good practice to reboot the server after demotion to ensure that it starts cleanly without any AD DS services.

After successfully demoting the DC, it will no longer function as a Domain Controller, and you can repurpose it as needed or retire it from your network. Make sure to update DNS settings and clean up any references to the demoted DC in your DNS infrastructure, DHCP settings, and other services as necessary.