param(
    [Parameter(Mandatory=$true)][string]$TemplatesPath
)

Write-Host "Converting ARM templates to Bicep..."

# Ensure bicep CLI is installed (assuming done)
$bicepFilesDir = Join-Path $TemplatesPath "bicep"

if (!(Test-Path $bicepFilesDir)) {
    New-Item -ItemType Directory -Path $bicepFilesDir | Out-Null
}

$armTemplates = Get-ChildItem $TemplatesPath -Filter *.json -File
foreach ($armTemplate in $armTemplates) {
    $bicepFileName = ($armTemplate.BaseName + ".bicep")
    $bicepFilePath = Join-Path $bicepFilesDir $bicepFileName

    Write-Host "Decompiling $($armTemplate.Name) to Bicep..."
    az bicep decompile --file $armTemplate.FullName --outFile $bicepFilePath
}
