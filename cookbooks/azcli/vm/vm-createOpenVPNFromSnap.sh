# Creates RG and the lowest cost VM with Std SSD basic public static IP from an existing OpenVPN VM snapshot
# Author: Chad Paynter

snapName=""
snapRG=""
location="australiaeast"
vmRG="rg-myopenvpn"

snapshotId=$(az snapshot show --name $snapName --resource-group $snapRG --query id --output tsv)
az group create -n $vmRG -l $location
az disk create --resource-group $vmRG --name "disk-myopenvm" --sku "Standard_LRS" --size-gb 32 --source $snapshotId
az network public-ip create --resource-group $vmRG --name "ip-myopenvpn" --version IPv4 --sku Basic --allocation-method Static --location $location
az vm create --name "vm-myopenvpn" --resource-group $vmRG --attach-os-disk "disk-myopenvm" --os-type linux --location $location --nsg "nsg-myopenvpn" --public-ip-address "ip-myopenvpn" --vnet-name "vnet-myopenvpn" --size "Standard_B1s" --plan-name "openvpnas" --plan-publisher "openvpn" --plan-product "openvpnas"
az network nsg rule create --resource-group $vmRG --nsg-name nsg-myopenvpn --name allow-https --protocol tcp  --priority 1100 --destination-port-range 443 --access Allow
az network public-ip show -n "ip-myopenvpn" -g $vmRG -o tsv --query "ipAddress"