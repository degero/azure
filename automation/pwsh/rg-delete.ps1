param (
  [string]$SubscriptionId,
  [string]$AutomationRG,
  [string]$AutomationName,
  [string]$RG
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
if (-not $rg) {
  $rg = Read-Host "rg"
}

$runbookName = "rg-delete"
$params = [ordered]@{"SubscriptionId" = $SubscriptionId; "rg" = $rg }

Write-Host "Deleting resource group and resources...."
$Job = Start-AzAutomationRunbook -AutomationAccountName $AutomationName -Name $runbookName -ResourceGroupName $AutomationRG -Parameters $params -Wait
Get-AzAutomationJobOutput -AutomationAccountName $AutomationName -Id $Job.JobId -ResourceGroupName $AutomationRG -Stream "Any"
Read-Host -Prompt "Press enter to close"