param(
    [Parameter(Mandatory=$true)][string]$TemplatesPath
)

Write-Host "Converting ARM templates to Terraform..."

$terraformFilesDir = Join-Path $TemplatesPath "terraform"

if (!(Test-Path $terraformFilesDir)) {
    New-Item -ItemType Directory -Path $terraformFilesDir | Out-Null
}

$armTemplates = Get-ChildItem $TemplatesPath -Filter *.json -File
foreach ($armTemplate in $armTemplates) {
    $tfFileName = ($armTemplate.BaseName + ".tf")
    $tfFilePath = Join-Path $terraformFilesDir $tfFileName

    Write-Host "Converting $($armTemplate.Name) to Terraform..."
    # Hypothetical command: arm2terraform
    arm2terraform -input $armTemplate.FullName -output $tfFilePath
}
