Write-Host "Validating converted IaC files..."

$scriptDir = Split-Path $MyInvocation.MyCommand.Path
$bicepDir = Join-Path (Split-Path $scriptDir) "sample-arm-templates\bicep"
$tfDir = Join-Path (Split-Path $scriptDir) "sample-arm-templates\terraform"

# Validate Bicep files
$bicepFiles = Get-ChildItem $bicepDir -Filter *.bicep
foreach ($file in $bicepFiles) {
    Write-Host "Validating Bicep file: $($file.Name)"
    $bicepResult = az bicep build --file $file.FullName 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Bicep validation failed for $($file.Name): $bicepResult"
        exit 1
    }
}

# Validate Terraform files
Set-Location $tfDir
Write-Host "Initializing Terraform..."
terraform init -no-color | Out-Null
Write-Host "Validating Terraform files..."
$tfValidate = terraform validate -no-color
if ($LASTEXITCODE -ne 0) {
    Write-Error "Terraform validation failed: $tfValidate"
    exit 1
}

Write-Host "All conversions validated successfully!"
