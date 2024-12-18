param(
    [Parameter(Mandatory=$true)]
    [string]$AppName,

    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup,

    [Parameter(Mandatory=$true)]
    [string]$ActiveSlot,

    [Parameter(Mandatory=$true)]
    [string]$InactiveSlot
)

Write-Host "Starting Blue-Green Deployment..."
Write-Host "Active Slot: $ActiveSlot, Inactive Slot: $InactiveSlot"

# Load Deployment Config
$configPath = Join-Path (Split-Path $MyInvocation.MyCommand.Path) 'config\webapp-settings.json'
if (!(Test-Path $configPath)) {
    Write-Error "Configuration file not found at $configPath"
    exit 1
}

$config = Get-Content $configPath | ConvertFrom-Json

# Example: Deploy a package to the inactive slot
Write-Host "Deploying to $InactiveSlot slot..."
$deploymentSource = $config.packageUrl # e.g., a zip package URL for the web app
if ([string]::IsNullOrEmpty($deploymentSource)) {
    Write-Error "No deployment package URL specified in config."
    exit 1
}

$deployResult = az webapp deployment source config-zip `
    --resource-group $ResourceGroup `
    --name $AppName `
    --slot $InactiveSlot `
    --src $deploymentSource 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Error "Deployment to $InactiveSlot slot failed: $deployResult"
    exit 1
}

Write-Host "Deployment to $InactiveSlot slot complete. Running Health Checks..."

# Health Check URL (the inactive slot might have a unique URL)
$inactiveUrl = "https://$($AppName)-$($InactiveSlot).azurewebsites.net/health"
$healthCheckPass = $false
$maxAttempts = 5
$attempt = 1

while (-not $healthCheckPass -and $attempt -le $maxAttempts) {
    Write-Host "Health Check Attempt $attempt: $inactiveUrl"
    try {
        $response = Invoke-WebRequest -Uri $inactiveUrl -UseBasicParsing -TimeoutSec 10
        if ($response.StatusCode -eq 200) {
            Write-Host "Health check succeeded on attempt $attempt."
            $healthCheckPass = $true
        } else {
            Write-Host "Health check failed with status code: $($response.StatusCode). Retrying..."
        }
    } catch {
        Write-Host "Health check failed due to exception: $($_.Exception.Message). Retrying..."
    }

    Start-Sleep -Seconds 10
    $attempt++
}

if (-not $healthCheckPass) {
    Write-Error "Health checks failed after $maxAttempts attempts. Reverting deployment..."
    # If health checks fail, you might just log here or redeploy the previous version
    # For now, we simply exit with error. The rollback can be more complex depending on your scenario.
    exit 1
}

Write-Host "Health checks passed. Ready to perform slot swap."
# The actual slot swap is done by the pipeline after this script succeeds.
