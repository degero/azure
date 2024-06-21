$runbookName = "rg-delete"
$automationRG = ""
$automationName = ""
$params = [ordered]@{"subscriptionId" = "" }
# Author: Chad Paynter

Write-Host "Deleting resource group and resources...."
$Job = Start-AzAutomationRunbook -AutomationAccountName $runbookName -Name $automationName -ResourceGroupName $automationRG -Parameters $params -Wait
Get-AzAutomationJobOutput -AutomationAccountName $automationName -Id $Job.JobId -ResourceGroupName $automationRG -Stream "Any"
Read-Host -Prompt "Press enter to close"