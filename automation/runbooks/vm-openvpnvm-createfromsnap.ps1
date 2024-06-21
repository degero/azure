Param
(
  [Parameter (Mandatory = $true)]
  [String] $subscriptionId,
  
  [Parameter (Mandatory = $true)]
  [String] $snapshotName,

  [Parameter (Mandatory = $true)]
  [String] $snapshotRG,

  [Parameter (Mandatory = $false)]
  [String] $rg = "rg-myopenvpn",

  [Parameter (Mandatory = $false)]
  [String] $location = "australiaeast"
)
# Creates RG and the lowest cost VM with Std SSD basic public static IP from an existing OpenVPN VM snapshot
# Author: Chad Paynter
"This runbook requires contributor on subscription and a snapshot of an Open VPN Access Server"
try {
  "Logging in to Azure..."
  az login --identity
  "Setting subscription"
  az account set -s $subscriptionId
}
catch {
  Write-Error -Message $_.Exception
  throw $_.Exception
}

$snapshotId = $(az snapshot show --name $snapshotName --resource-group $snapshotRG --query id --output tsv)
az group create -n $rg -l $location
az disk create --resource-group $rg --name "disk-myopenvm" --sku "Standard_LRS" --size-gb 32 --source $snapshotId
az network public-ip create --resource-group $rg --name "ip-myopenvpn" --version IPv4 --sku Basic --allocation-method Static --location $location
az vm create --name "vm-myopenvpn" --resource-group $rg --attach-os-disk "disk-myopenvm" --os-type linux --location $location --nsg "nsg-myopenvpn" --public-ip-address "ip-myopenvpn" --vnet-name "vnet-myopenvpn" --size "Standard_B1s" --plan-name "openvpnas" --plan-publisher "openvpn" --plan-product "openvpnas"
az network nsg rule create --resource-group $rg --nsg-name nsg-myopenvpn --name allow-https --protocol tcp  --priority 1100 --destination-port-range 443 --access Allow

"Public IP for VPN"
[OutputType([string])]
$output = $(az network public-ip show -n "ip-myopenvpn" -g $rg -o tsv --query "ipAddress")
Write-Output $output
