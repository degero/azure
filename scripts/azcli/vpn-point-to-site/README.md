# VPN Gateway (Basic) to VNET

Doco is missing steps between different scripting / deployment tools. This script is based on 
https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-point-to-site-rm-ps

These steps are focused on Windows + Powershell but can be adapted to other OSs

You can combine with the vm-linux scripts to access private vms on a vnet

## Specs

Lowest cost option

- VPN Gateway basic sku 
- Public IP Basic sku dynamic ip allocation

## Setup VNet, Public IP and VPN Gateway 

This uses the lowest cost option (basic) for a route based VPN, it includes subnets default and vm 
for connecting/accessing your azure resource

- Run vpngateway-p2s-create.ps1 file (use passing optional paramters to attach to an existing VNET)

This will setup infra and guide you through the below 

## Manual Setup Certificate authentication

Create your certs using these pwsh cmd (if using windows+pwsh) if using certificate authentication
- Run create-selfsigned-server-client-certs.ps1
- WIN + r > certmgr.msc > Certificates Current User > Personal > Certs > P2SRootCert
- export .cer base-64 of server cert no priv key in the 
- (optional) export .pfx of client cert with priv key enable cert privacy and include all certs checked for distrubtion to clients
- copy root cert to this directory 
- Run vpngateway-p2s-certs.ps1
- Install the client for your OS (run as administrator)
- In your OS VPN settings there should be 'Vnet' vpn connect using this
- Congrats! 🎉

If using other auth methods or OS than windows see this article to create and install certs on OS
you can then use the cert with steps 5 onwards.

https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-point-to-site-rm-ps#cer 

## Download non-native clients

You can also use other clients including OpenVPN in this guide
https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-point-to-site-rm-ps#cer

OR

[Azure VPN client (windows)](https://apps.microsoft.com/detail/9np355qt2sqb?hl=en-US&gl=KH#activetab=pivot:overviewtab)

If using certificate auth, you can use the profile xml from the downloaded client in the steps above with the non-native client

## Further Reading

https://learn.microsoft.com/en-us/azure/vpn-gateway/create-routebased-vpn-gateway-cli