# Automated Azure Resource Tagging and Governance

This project automates and enforces standardized tags on Azure resources. By applying tags consistently, organizations can improve cost allocation, identify ownership, and maintain governance standards. It also integrates with Azure Policy for ongoing compliance and can be extended to report compliance status to Log Analytics.

## Features

- **Automated Tagging:**  
  A PowerShell script applies required tags (e.g., `cost-center` and `environment`) to all resources within a given subscription.
  
- **Policy-Based Governance:**  
  An Azure Policy definition (example provided) ensures that resources without required tags cannot be created, maintaining long-term governance.
  
- **Compliance Reporting:**  
  Another script checks tag compliance and can be extended to send results to Log Analytics, open GitHub issues, or integrate with reporting dashboards.

## Directory Structure



## How It Works

1. **apply-tags.ps1**:  
   - Iterates over all resources in the specified subscription.
   - Applies the tags listed in `required-tags.json` (or pipeline variables) to each resource.

2. **check-compliance.ps1**:  
   - Scans all resources to ensure the required tags are present.
   - Logs any non-compliant resources.
   - Can be extended to forward findings to Log Analytics or raise alerts.

3. **Azure Policy (policy-definition.json)**:  
   - Prevents non-compliant resources from being created.
   - Ensures long-term governance by enforcing required tags at creation time.

## Prerequisites

- **Azure CLI or PowerShell Az Module** for local tests.
- A configured **Azure DevOps service connection** for the pipeline to deploy and manage resources.
- Appropriate **role-based access** for reading and tagging Azure resources.

## How to Use

1. **Setup Variables in azure-pipelines.yml**:  
   Update `subscriptionId`, `costCenter`, and `environment` as required.
   
2. **Run the Pipeline**:  
   On committing to the repository’s `main` branch, the pipeline will:
   - Apply required tags to all existing resources.
   - Check for compliance and log findings.

3. **Assign the Azure Policy**:  
   Use `az policy assignment create` to assign `policy-definition.json` to your subscription. This step ensures future resources remain compliant.

```bash
az policy assignment create --name "RequireTags" \
  --policy definition.json \
  --scope "/subscriptions/<your-subscription-id>"
