[CmdletBinding()]
param(
  [Parameter(Mandatory = $true, HelpMessage = "Name for the VM")]
  [string]$vmName,
    
  [Parameter(Mandatory = $true, HelpMessage = "Azure region name")]
  [string]$location,
    
  [Parameter(Mandatory = $true, HelpMessage = "Your preferred short name for this region eg 'eastus' = 'eus'")]
  [ValidateLength(3, 3)]
  [string]$locationShort,

  [Parameter(Mandatory = $false, HelpMessage = "Create public IP (y/n)")]
  [string]$publicIP,
  
  [Parameter(Mandatory = $false)]
  [string]$vnetName,

  [Parameter(Mandatory = $false)]
  [string]$rgName
)


# Set default values if not provided
if ([string]::IsNullOrEmpty($rgName)) {
  $rgName = "rg-$vmName-$locationShort"
}
if ([string]::IsNullOrEmpty($vnetName)) {
  $vnetName = "vnet-$vmName-$locationShort"
}
if ([string]::IsNullOrEmpty($publicIP)) {
  Read-Host -Prompt "Create public IP (y/n)?" -OutVariable publicIP
}

az group create --name $rgName --location $location --output table

# Create VNET and Subnets
az network vnet create --resource-group $rgName --name $vnetName --address-prefix 10.1.0.0/16 --subnet-name default --subnet-prefix 10.1.0.0/24 --output table
az network vnet subnet create --vnet-name $vnetName -n vm -g $rgName --address-prefix 10.1.1.0/24 --output table

# Create NSG with SSH rule
$nsgName = "nsg-$vmName-$locationShort"
az network nsg create --resource-group $rgName --name $nsgName --output table

az network nsg rule create --resource-group $rgName --nsg-name $nsgName --name "Allow-SSH-Inbound" --protocol tcp --priority 1000 --destination-port-range 22 --access allow --output table

$nicName = "nic-$vmName-$locationShort"

if ($publicIP -eq "y") {

  az network public-ip create `
    --name "pip-$vmName-$locationShort" `
    --resource-group $rgName `
    --allocation-method Static `
    --sku Standard `
    --output table

  # Create NIC with public and private IPy
  az network nic create --resource-group $rgName --name $nicName --vnet-name $vnetName --subnet vm --network-security-group $nsgName --public-ip "pip-$vmName-$locationShort" --output table

}
else {

  # Create NIC with private IP only
  az network nic create --resource-group $rgName --name $nicName --vnet-name $vnetName --subnet vm --network-security-group $nsgName --output table

}

$vmName = "vm-$vmName-$locationShort"
# This will install ssh key in ur ~/.ssh folder
az vm create --resource-group $rgName --name $vmName --image Ubuntu2404 --admin-username azureuser --generate-ssh-keys --size Standard_B1ls --storage-sku StandardSSD_LRS --nics $nicName --enable-vtpm true --enable-secure-boot true --output table 

#IP aaddress of VM
az vm show --name $vmName --resource-group $rgName --show-details --query [publicIPs] --output tsv

## Now you can ssh in on ssh azureuser@<publicIP> 