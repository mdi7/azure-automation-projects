param(
    [Parameter(Mandatory=$true)][string]$SubscriptionId
)

Write-Host "Checking compliance for subscription: $SubscriptionId"

$configPath = Join-Path (Split-Path $MyInvocation.MyCommand.Path) 'config\required-tags.json'
if (!(Test-Path $configPath)) {
    Write-Error "Required tags config not found at $configPath"
    exit 1
}

$requiredTags = (Get-Content $configPath | ConvertFrom-Json)

$resources = az resource list --subscription $SubscriptionId | ConvertFrom-Json
$nonCompliant = @()

foreach ($r in $resources) {
    $missingTags = @()
    foreach ($tagKey in $requiredTags.psobject.Properties.Name) {
        if ((-not $r.tags) -or (-not $r.tags[$tagKey])) {
            $missingTags += $tagKey
        }
    }

    if ($missingTags.Count -gt 0) {
        $nonCompliant += [PSCustomObject]@{
            "ResourceId"   = $r.id
            "MissingTags"  = ($missingTags -join ", ")
        }
    }
}

if ($nonCompliant.Count -eq 0) {
    Write-Host "All resources are compliant."
} else {
    Write-Warning "Found non-compliant resources:"
    $nonCompliant | Format-Table
    # Optionally, send data to Log Analytics or open GitHub Issues.
    # For now, just log it. You can integrate with Log Analytics via az monitor commands or Kusto queries.
}
