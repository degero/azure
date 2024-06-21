$runbookName = "vm-openvpnvm-createfromsnap"
$automationRG = ""
$automationName = ""
$params = [ordered]@{"subscriptionId" = ""; "snapshotName" = ""; "snapshotRG" = "" }
# Author: Chad Paynter

Start-AzAutomationRunbook -AutomationAccountName $automationName -Name $runbookName -ResourceGroupName $automationRG -Parameters $params -Wait
Read-Host -Prompt "Press enter to close"