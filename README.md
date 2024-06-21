# Azure Resources

My collection of handy Azure resources (Scripts, IAC etc)


## automation

### pwsh

To trigger the runbooks below

### runbooks

These are all using Azure CLI commands and require Pwrshl 7.2 for your runbook.
You will need to create an automation account in azure and a [managed identity](https://learn.microsoft.com/en-us/azure/automation/learn/powershell-runbook-managed-identity) for it to execute with, the comments in runbooks will outline the required permissions

- openvpnvm-createfromsnap.ps1 - Use an existing VM Disk snapshot to create a new RG + VM 
- rg-delete.ps1 - Delete RG for OpenVPN VM created in openvpnvm-createfromsnap.ps1


## cookbooks

### azcli

#### vm

These scripts are interactive for powershell to input details, note VM sku's and location need to be changed in script

- vm-createOpenVPNFromSnap - Creates the lowest cost VM with Std SSD basic public static IP from an existing OpenVPN VM snapshot
- vm-createOpenVPNFromMarketplace - Creates the lowest cost VM with Std SSD basic public static IP from a Marketplace image