
param (
  [string]$SubscriptionId,
  [string]$AutomationRG,
  [string]$AutomationName,
  [string]$SnapshotName,
  [string]$SnapshotRG
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
if (-not $SnapshotName) {
  $SnapshotName = Read-Host "SnapshotName"
}
if (-not $SnapshotRG) {
  $SnapshotRG = Read-Host "SnapshotRG"
}

$RunbookName = "vm-openvpnvm-createfromsnap"
$params = [ordered]@{"subscriptionId" = $SubscriptionId; "snapshotName" = $SnapshotName; "snapshotRG" = $SnapshotRG }

Start-AzAutomationRunbook -AutomationAccountName $AutomationName -Name $RunbookName -ResourceGroupName $AutomationRG -Parameters $params -Wait
Read-Host -Prompt "Press enter to close"