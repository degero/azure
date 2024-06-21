# Creates VM from marketplace with public IP / 443 access
# Author: Chad Paynter

location = "australiaeast"
rg = "rg-myvm"
vmName = "vm-myvm"
publisher = ""
offer = ""
sku = ""
adminUser = ""
adminPass = ""
location = "australiaeast"
vmSize = "Standard_B1s"
vmStorageType = "StandardSSD_LRS"

az group create -n $rg -l $location

$imageId=$(az vm image list --publisher $publisher --offer $offer --sku $sku --all --output tsv --query "[0].urn")
az vm image accept-terms --urn $imageId

az network public-ip create --resource-group $rg --name "ip-myopenvpn" --version IPv4 --sku Basic --allocation-method Static --location $location

az vm create --name $vmName  --resource-group $rg --image $imageId --admin-username $adminUser --admin-password $adminPass --location $location --nsg "nsg-myopenvpn" --public-ip-address "ip-myopenvpn" --vnet-name "vnet-myopenvpn" --size $vmSize --storage-sku $vmStorageType

az network nsg rule create --resource-group $rg --nsg-name nsg-myopenvpn --name allow-https --protocol tcp  --priority 1100 --destination-port-range 443 --access Allow

"Public IP"
az network public-ip show -n "ip-myopenvpn" -g $rg -o tsv --query "ipAddress"