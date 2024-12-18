param(
    [Parameter(Mandatory=$true)][string]$GitRepoUrl,
    [Parameter(Mandatory=$true)][string]$GitBranch
)

Write-Host "Pushing changes to GitHub repository: $GitRepoUrl on branch $GitBranch"

# Assume git is installed on the build agent.  
$tempDir = Join-Path $env:BUILD_SOURCESDIRECTORY "converted-iac-output"
if (Test-Path $tempDir) {
    Remove-Item -Recurse -Force $tempDir
}
New-Item -ItemType Directory -Path $tempDir | Out-Null

# Copy the converted files to temp directory
Copy-Item (Join-Path $env:BUILD_SOURCESDIRECTORY "iac-conversion-tool\sample-arm-templates\bicep") $tempDir -Recurse
Copy-Item (Join-Path $env:BUILD_SOURCESDIRECTORY "iac-conversion-tool\sample-arm-templates\terraform") $tempDir -Recurse

Set-Location $tempDir
git init
git remote add origin $GitRepoUrl
git checkout -b $GitBranch
git add .
git commit -m "Automated IaC conversion from ARM templates to Bicep & Terraform"
git push origin $GitBranch --force
