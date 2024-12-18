param(
    [Parameter(Mandatory=$true)][string]$CertPath,
    [Parameter(Mandatory=$true)][string]$KeyPath,
    [Parameter(Mandatory=$true)][string]$OutputPfxPath
)

Write-Host "Exporting certificate and key to PFX: $OutputPfxPath"
$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($CertPath)
$cert.Export('PFX','') | Out-File $OutputPfxPath -Encoding byte
Write-Host "PFX file created at $OutputPfxPath"
