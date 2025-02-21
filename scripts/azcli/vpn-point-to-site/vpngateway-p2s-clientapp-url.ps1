param(
  [Parameter(Mandatory = $true)]
  [string]$vpnGatewayName,
    
  [Parameter(Mandatory = $true)]
  [string]$rgName
)

# Get the VPN client configuration and profile URL
az network vnet-gateway vpn-client generate --name $vpnGatewayName --resource-group $rgName --authentication-method "EapTls"  