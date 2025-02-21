[CmdletBinding()]
param(
  [Parameter(Mandatory = $true, HelpMessage = "Name for app")]
  [string]$appName,
    
  [Parameter(Mandatory = $true, HelpMessage = "Azure region name")]
  [string]$location,
    
  [Parameter(Mandatory = $true, HelpMessage = "Your preferred short name for this region eg 'eastus' = 'eus'")]
  [ValidateLength(3, 3)]
  [string]$locationShort,
  
  [Parameter(Mandatory = $false)]
  [string]$vnetName,

  [Parameter(Mandatory = $false)]
  [string]$rgName
)

# Set default values if not provided
if ([string]::IsNullOrEmpty($rgName)) {
  $rgName = "rg-$appName-$locationShort"
}
if ([string]::IsNullOrEmpty($vnetName)) {
  $vnetName = "vnet-$appName-$locationShort"
  # Create resource group as we arent attaching to existing vnet
  az group create --name $rgName --location $location --output tsv
}



# Create VNet with default subnet only if vnetName was not provided
if ($vnetName -eq "vnet-$appName-$locationShort") {
  az network vnet create `
    -n $vnetName `
    -g $rgName `
    -l $location `
    --address-prefix "10.1.0.0/16" `
    --subnet-name "default" `
    --subnet-prefix "10.1.0.0/24" `
    --output tsv

  # Create VM subnet
  az network vnet subnet create `
    --vnet-name $vnetName `
    -n "vm" `
    -g $rgName `
    --address-prefix "10.1.1.0/24" `
    --output tsv
}

# Create gateway subnet
az network vnet subnet create `
  --vnet-name $vnetName `
  -n "gatewaysubnet" `
  -g $rgName `
  --address-prefix "10.1.255.0/27" `
  --output tsv

# Create public IP
az network public-ip create `
  --name "pip-$appName-$locationShort" `
  --resource-group $rgName `
  --allocation-method Dynamic `
  --sku Basic `
  --version IPv4 `
  --output tsv

# Create VPN Gateway
$vgwName = "vgw-$appName-$locationShort"
az network vnet-gateway create `
  --name $vgwName `
  --public-ip-addresses "pip-$appName-$locationShort" `
  --resource-group $rgName `
  --vnet $vnetName `
  --gateway-type Vpn `
  --vpn-type RouteBased `
  --sku Basic `
  --address-prefix "172.16.201.0/24" `
  --no-wait

Write-Host "VPN Gateway deployment started. Wait for the 'updating' status to complete in Azure Portal before configuring client Auth. You can configure certificate auth using create-selfsigned-server-client-certs.ps1 and vpngateway-p2s-certs.ps1 scripts."

Write-Host "Creating Server and Client certs on you local machine..."

$params = @{
  vpnGatewayName = $vgwName
  rgName         = $rgName
}
& ".\create-selfsigned-server-client-certs.ps1" 
& ".\vpngateway-p2s-certs.ps1" @params