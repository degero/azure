param (
  [string]$vmName,
  [string]$vmRG,
  [string]$action # start/stop/restart/deallocate
)

if (-not $vmName) {
  $vmName = Read-Host "vmName"
}
if (-not $vmRG) {
  $vmRG = Read-Host "vmRG"
}
if (-not $action) {
  $action = Read-Host "action[start/stop/restart/deallocate]"
}

switch -Exact ($action) {
  "start" {
    az vm start --resource-group $vmRG --name $vmName
    break
  }
  "stop" {
    az vm deallocate --resource-group $vmRG --name $vmName
    break
  }
  "restart" {
    az vm restart --resource-group $vmRG --name $vmName
    break
  }
  'deallocate' {
    az vm deallocate --resource-group $vmRG --name $vmName
    break
  }
  default {
    Write-Host "Invalid action. Please use 'start', 'stop', 'restart', or 'deallocate'."
    break
  }
}

Read-Host -Prompt "Press enter to close"