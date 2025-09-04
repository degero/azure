# Connect to Azure (uncomment if not already connected)
# Connect-AzAccount

# Get the current date for the report name
$date = Get-Date -Format "yyyy-MM-dd"
$reportPath = "AzureInventory_$date.csv"

# Initialize array to store inventory items
$inventory = @()

# Get all subscriptions
$subscriptions = Get-AzSubscription

foreach ($sub in $subscriptions) {
    # Set context to current subscription
    Set-AzContext -Subscription $sub.Id

    Write-Host "Processing subscription: $($sub.Name)"

    # Get all resource groups
    $resourceGroups = Get-AzResourceGroup

    foreach ($rg in $resourceGroups) {
        # Get all resources in the resource group
        $resources = Get-AzResource -ResourceGroupName $rg.ResourceGroupName

        foreach ($resource in $resources) {
            # Get tags
            $tags = if ($resource.Tags) { 
                ($resource.Tags.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join '; ' 
            } else { 
                "No tags" 
            }

            # Get additional details based on resource type
            $details = switch ($resource.Type) {
                "Microsoft.Compute/virtualMachines" {
                    $vm = Get-AzVM -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name
                    @{
                        Size = $vm.HardwareProfile.VmSize
                        OS = $vm.StorageProfile.OsDisk.OsType
                    }
                }
                "Microsoft.Storage/storageAccounts" {
                    $storage = Get-AzStorageAccount -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name
                    @{
                        SKU = $storage.Sku.Name
                        Kind = $storage.Kind
                    }
                }
                default { @{} }
            }

            # Create inventory object
            $inventoryItem = [PSCustomObject]@{
                SubscriptionId = $sub.Id
                SubscriptionName = $sub.Name
                ResourceGroup = $resource.ResourceGroupName
                ResourceName = $resource.Name
                ResourceType = $resource.Type
                Location = $resource.Location
                Tags = $tags
                ResourceId = $resource.Id
                Details = ($details | ConvertTo-Json -Compress)
            }

            $inventory += $inventoryItem
        }
    }
}

# Export to CSV
$inventory | Export-Csv -Path $reportPath -NoTypeInformation

Write-Host "Inventory exported to $reportPath"

# Optional: Generate summary statistics
$summary = [PSCustomObject]@{
    TotalSubscriptions = $subscriptions.Count
    TotalResourceGroups = ($inventory | Select-Object ResourceGroup -Unique).Count
    TotalResources = $inventory.Count
    ResourceTypes = ($inventory | Group-Object ResourceType | Select-Object Name, Count)
    Locations = ($inventory | Group-Object Location | Select-Object Name, Count)
}

Write-Host "`nInventory Summary:"
$summary | Format-List