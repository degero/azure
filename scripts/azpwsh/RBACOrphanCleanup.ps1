$ResourceGroupName = ""
# TODO Chad - add in delete functionality + audit output for transparency

$roleAssignments = az role assignment list --all | ConvertFrom-Json
$orphaned = $roleAssignments | Where-Object { ($_.principalName -eq "")  } #-and ($_.scope -match "resourcegroups/$ResourceGroupName")
Write-Host "Orphaned assignments:" $orphaned.Count
$orphaned | ForEach-Object { Write-Host $_.roleDefinitionName " " $_.principalType " " $_.scope  } #az role assignment delete --ids $_.id