Param
(
  [Parameter (Mandatory = $true)]
  [String] $subscriptionId,
  
  [Parameter (Mandatory = $true)]
  [String] $vmName,

  [Parameter (Mandatory = $true)]
  [String] $vmRG,

  [Parameter (Mandatory = $true)]
  [String] $action # start/stop/restart
)
# Start/Stop/Restart VM
# Author: Chad Paynter
"This runbook requires VM Contributor role on the VM or a custom role"
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

$action = "start"  # Replace with your actual value
$result = ""
switch ($action) {
  "start" {
    $result = "Starting the service..."
    az vm start -g $vmRG -n $vmName
  }
  "stop" {
    $result = "Stopping the service..."
    az vm stop -g $vmRG -n $vmName
  }
  "restart" {
    $result = "Restarting the service..."
    az vm restart -g $vmRG -n $vmName
  }
  default {
    Write-Output "Invalid action: $action"
    # Handle any other cases here
  }
}
[OutputType([string])]
$output = $result
Write-Output $output