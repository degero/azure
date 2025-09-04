Param
(
  [Parameter (Mandatory = $true)]
  [String] $subscriptionId,
  [Parameter (Mandatory = $true)]
  [String] $cappName,
  [Parameter (Mandatory = $true)]
  [String] $rgName
)

# Stop ContainerApp
# Author: Chad Paynter
"This runbook requires contributor on subscription / RG"
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

Stop-AzContainerApp -Name $cappName -ResourceGroupName $rgName