param(
    [Parameter(Mandatory=$true)][string]$KeyVaultName,
    [Parameter(Mandatory=$true)][string]$AppGatewayName,
    [Parameter(Mandatory=$true)][string]$ResourceGroupName,
    [Parameter(Mandatory=$true)][string]$WebAppName
)

Write-Host "Starting SSL certificate renewal process..."

# Load domain configuration
$scriptDir = Split-Path $MyInvocation.MyCommand.Path
$domainsPath = Join-Path $scriptDir "config\domains.json"
if (!(Test-Path $domainsPath)) {
    Write-Error "domains.json config file not found."
    exit 1
}

$domains = Get-Content $domainsPath | ConvertFrom-Json

foreach ($domain in $domains.domains) {
    Write-Host "Requesting certificate for $($domain.name)..."
    # Call shell script to request/renew cert from Let's Encrypt using ACME client (e.g., Certbot)
    # The script get-letsencrypt-cert.sh should handle domain validation (DNS or HTTP challenge) and produce a PFX cert
    $certResult = & "$scriptDir\scripts\get-letsencrypt-cert.sh" $domain.name $domain.email
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Certificate request failed for $($domain.name): $certResult"
        continue
    }

    $pfxPath = Join-Path $scriptDir "scripts\${($domain.name)}.pfx"
    if (!(Test-Path $pfxPath)) {
        Write-Error "PFX certificate not found at $pfxPath"
        continue
    }

    Write-Host "Uploading certificate for $($domain.name) to Key Vault..."
    # Convert to a secret in Key Vault
    az keyvault certificate import --vault-name $KeyVaultName --name $domain.name --file $pfxPath | Out-Null

    # Update Application Gateway or Web App with new certificate
    # If using App Gateway:
    # - Retrieve the secret ID
    $secretId = az keyvault secret show --vault-name $KeyVaultName --name $domain.name --query "id" -o tsv
    Write-Host "Updating Application Gateway HTTPS listener..."
    az network application-gateway ssl-cert update --gateway-name $AppGatewayName --resource-group $ResourceGroupName --name $domain.name --key-vault-secret-id $secretId

    # For Web App (Optional if using Web Apps instead of App Gateway):
    # az webapp config ssl upload --resource-group $ResourceGroupName --name $WebAppName --certificate-file $pfxPath --certificate-password ""  
    # az webapp config ssl bind --name $WebAppName --resource-group $ResourceGroupName --certificate-thumbprint <thumbprint> --ssl-type SNI

    # Clean up PFX if desired
    Remove-Item $pfxPath -Force
}

Write-Host "SSL certificate renewal process complete!"
