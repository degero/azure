Param
(
  [Parameter (Mandatory = $true)]
  [String] $subscriptionId,
  
  [Parameter (Mandatory = $true)]
  [String] $rg
)
# Delete RG
# Author: Chad Paynter

"This runbook requires contributor role on subscription"
try {
  "Logging in to Azure..."
  az login --identity
  "Setting subscription"
  az account set -s $subscriptionId
}
catch {
  Write-Error -Message $_.Exception
  throw $_.Exception
}

"Deleting resource group: "
Write-Host $rg
az group delete -n $rg -f Microsoft.Compute/virtualMachines -y 