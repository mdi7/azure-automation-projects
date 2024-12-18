param(
    [Parameter(Mandatory=$true)][string]$SubscriptionId,
    [Parameter(Mandatory=$true)][string]$CostCenter,
    [Parameter(Mandatory=$true)][string]$EnvironmentName
)

Write-Host "Applying standard tags to all resources in subscription: $SubscriptionId"

# Retrieve desired tags from config file if needed
$configPath = Join-Path (Split-Path $MyInvocation.MyCommand.Path) 'config\required-tags.json'
if (Test-Path $configPath) {
    $requiredTags = (Get-Content $configPath | ConvertFrom-Json)
} else {
    $requiredTags = @{
        "cost-center" = $CostCenter
        "environment" = $EnvironmentName
    }
}

$tagParameters = ""
foreach ($k in $requiredTags.Keys) {
    $tagParameters += "$k=$($requiredTags[$k]) "
}

$resourcesJson = az resource list --subscription $SubscriptionId | ConvertFrom-Json
foreach ($r in $resourcesJson) {
    Write-Host "Tagging resource: $($r.id)"
    az resource tag --ids $r.id --tags $tagParameters 2>&1 | Out-Null
}

Write-Host "Tagging complete!"
