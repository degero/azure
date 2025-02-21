# Azure VM (Linux)

Create a basic lowest cost (Standard_B1ls) Linux VM with 
- private IP 
- (optional) Public IP standard sku static
- new VNET 
- STD SSD 
- .5GB RAM 
- 32G disk. 
- free AZ VM licence Ubuntu 16.04 LTS with Gen2 sec 
Approx costs: $USD0.014 / hr
- NSG
- VNet
- NIC
- Optional static public IP
- ssh auth and cert installed in your .ssh folder
- uses [trusted launch](https://learn.microsoft.com/en-us/azure/virtual-machines/trusted-launch-portal?tabs=portal%2Cportal3%2Cportal2#deploy-a-trusted-launch-vm)

## Steps

- Run vm-linux-basic.ps1 (specify if you want public IP)