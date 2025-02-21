$params = @{
  Type              = 'Custom'
  Subject           = 'CN=P2SRootCert'
  KeySpec           = 'Signature'
  KeyExportPolicy   = 'Exportable'
  KeyUsage          = 'CertSign'
  KeyUsageProperty  = 'Sign'
  KeyLength         = 2048
  HashAlgorithm     = 'sha256'
  NotAfter          = (Get-Date).AddMonths(24)
  CertStoreLocation = 'Cert:\CurrentUser\My'
}
$cert = New-SelfSignedCertificate @params

$params = @{
  Type              = 'Custom'
  Subject           = 'CN=P2SChildCert'
  DnsName           = 'P2SChildCert'
  KeySpec           = 'Signature'
  KeyExportPolicy   = 'Exportable'
  KeyLength         = 2048
  HashAlgorithm     = 'sha256'
  NotAfter          = (Get-Date).AddMonths(18)
  CertStoreLocation = 'Cert:\CurrentUser\My'
  Signer            = $cert
  TextExtension     = @(
    '2.5.29.37={text}1.3.6.1.5.5.7.3.2')
}
New-SelfSignedCertificate @params

Write-Host "------------------------------------------------"

Write-Host "Certificates created."
Write-Host "You can view these in WIN + r > certmgr.msc > Certificates Current User > Personal > Certs > P2SRootCert"
Write-Host "Export the root cert  to a .cer file as base-64 of with private key. Enter the file path in the prompts below."

