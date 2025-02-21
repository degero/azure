param(
  [Parameter(Mandatory = $true)]
  [string]$vpnGatewayName,
    
  [Parameter(Mandatory = $true)]
  [string]$rgName,
    
  [Parameter(Mandatory = $true)]
  [string]$cerFilePath
)

if ([string]::IsNullOrEmpty($vpnGatewayName)) {
  Read-Host -Prompt "Enter name of target VPN gateway: " -OutVariable vpnGatewayName
}
if ([string]::IsNullOrEmpty($rgName)) {
  Read-Host -Prompt "Enter name of target Resource Group: " -OutVariable rgName
}
if ([string]::IsNullOrEmpty($cerFilePath)) {
  Read-Host -Prompt "Enter path of Server root .cer file: " -OutVariable cerFilePath
}

# If you wisht to use cert auth for your vpn clients
az network vnet-gateway root-cert create --name "YourRootCertName" --gateway-name $vpnGatewayName --resource-group $rgName --public-cert-data $cerFilePath

Write-Host "Download the VPN client package from the following URL and run as administrator"

$params = @{
  vpnGatewayName = $vpnGatewayName
  rgName         = $rgName
}

& ".\vpngateway-p2s-clientapp-url.ps1" @params

