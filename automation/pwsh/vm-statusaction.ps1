param (
  [string]$SubscriptionId,
  [string]$AutomationRG,
  [string]$AutomationName,
  [string]$VMName,
  [string]$VMRG,
  [string]$Action
)
# Author: Chad Paynter

if (-not $SubscriptionId) {
  $SubscriptionId = Read-Host "SubscriptionId"
}
if (-not $AutomationRG) {
  $AutomationRG = Read-Host "AutomationRG"
}
if (-not $AutomationName) {
  $AutomationName = Read-Host "AutomationName"
}
if (-not $VMName) {
  $VMName = Read-Host "VMName"
}
if (-not $VMRG) {
  $VMRG = Read-Host "VMRG"
}
if (-not $Action) {
  $Action = Read-Host "Action[start/stop/restart/deallocate]"
}

$runbookName = "vm-statusAction"
$params = [ordered]@{"subscriptionId" = $SubscriptionId; "vmName" = $VMName; "vmRG" = $VMRG; "Action" = $Action }
Start-AzAutomationRunbook -AutomationAccountName $automationName -Name $runbookName -ResourceGroupName $automationRG -Parameters $params -Wait
Read-Host -Prompt "Press enter to close"