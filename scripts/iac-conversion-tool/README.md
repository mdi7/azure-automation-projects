# Infrastructure as Code (IaC) Conversion Tool

This tool automates the conversion of Azure ARM templates into both Bicep and Terraform formats. It ensures that your IaC definitions remain up-to-date, validated, and version-controlled. By integrating with a CI/CD pipeline, the tool can continuously convert and validate templates, pushing clean outputs to a dedicated GitHub repository.

## Features

- **Automated Conversion:**  
  Uses `az bicep decompile` for ARM-to-Bicep and a third-party tool (e.g., `arm2terraform`) for ARM-to-Terraform conversion.

- **Validation:**  
  Runs `az bicep build` to validate Bicep files and `terraform validate` to verify Terraform files.

- **Version Control:**  
  Automatically pushes converted and validated IaC files to a designated GitHub repository, ensuring changes are tracked and reviewed.

## Directory Structure


iac-conversion-tool/ ├── azure-pipelines.yml # Pipeline definition for CI/CD ├── convert-arm-to-bicep.ps1 # Script to convert ARM -> Bicep ├── convert-arm-to-terraform.ps1 # Script to convert ARM -> Terraform ├── validate-conversions.ps1 # Validates the newly created Bicep & TF files ├── push-changes.ps1 # Pushes validated code to a GitHub repo ├── sample-arm-templates/ # Example input ARM templates │ ├── storage-account.json │ └── vnet.json ├── config/ │ ├── repo-settings.json │ └── validation-rules.json └── README.md


## Prerequisites

- **Azure CLI with Bicep Extension:**  
  Install the Bicep CLI:  
  ```bash
  az bicep install

  Terraform CLI:
Install Terraform to validate .tf files.

Third-Party ARM-to-Terraform Tool:
Example: arm2terraform (adjust the script according to the tool you use).

Git Installed on Build Agent:
Needed for pushing changes to GitHub.


How It Works
Pipeline Trigger:
When ARM templates are updated in sample-arm-templates/, the pipeline runs.

Conversion Steps:

convert-arm-to-bicep.ps1 generates .bicep files.
convert-arm-to-terraform.ps1 generates .tf files.
Validation:
validate-conversions.ps1 ensures the generated files are syntactically correct and follow the given rules.

Version Control Commit:
push-changes.ps1 commits and pushes the validated Bicep and Terraform files to the specified GitHub repository.

Customization
Validation Rules:
Edit config/validation-rules.json to define custom linting rules or checks.

Target Repository:
Update azure-pipelines.yml and repo-settings.json to point to your desired GitHub repo and branch.

Additional Conversion Targets:
Add more scripts to convert to other IaC frameworks if needed.

License
This project is licensed under the MIT License.