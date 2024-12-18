param(
    [Parameter(Mandatory=$true)][string]$ResourceGroupName,
    [Parameter(Mandatory=$true)][string]$ClusterName
)

Write-Host "Determining appropriate scale action for AKS cluster: $ClusterName in RG: $ResourceGroupName"

$scriptDir = Split-Path $MyInvocation.MyCommand.Path
$schedulePath = Join-Path $scriptDir "config\schedule.json"

if (!(Test-Path $schedulePath)) {
    Write-Error "Schedule file not found at $schedulePath"
    exit 1
}

$schedule = Get-Content $schedulePath | ConvertFrom-Json

# Example: The schedule.json might define target node counts for time windows.
# We'll just pick one time window for simplicity.
$currentHour = (Get-Date).Hour

$desiredConfig = $null
foreach ($entry in $schedule.scalingSchedule) {
    if ($currentHour -ge $entry.startHour -and $currentHour -lt $entry.endHour) {
        $desiredConfig = $entry
        break
    }
}

if ($null -eq $desiredConfig) {
    Write-Host "No matching time window found. Defaulting to baseline scale."
    $desiredNodeCount = $schedule.defaultNodeCount
} else {
    $desiredNodeCount = $desiredConfig.nodeCount
}

Write-Host "Scaling AKS to $desiredNodeCount nodes based on schedule."

# Example using Azure CLI directly:
$nodePoolName = "default" # Adjust as needed
$scaleResult = az aks scale --resource-group $ResourceGroupName --name $ClusterName --node-count $desiredNodeCount --nodepool-name $nodePoolName 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "Scaling failed: $scaleResult"
    exit 1
}

Write-Host "Successfully scaled $ClusterName to $desiredNodeCount nodes."
