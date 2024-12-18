# Blue-Green Deployment Orchestrator for Azure Web Apps

This project provides an automated Blue-Green deployment strategy for Azure Web Apps, ensuring zero-downtime deployments, health checks, and rollback capabilities. The provided scripts and pipeline configuration help streamline the process of updating a production web application slot with minimal risk.

## Overview

- **Blue-Green Deployment Strategy:**  
  The application runs in two parallel environments (slots):  
  - **Active Slot (e.g., Blue):** Currently serving live production traffic.  
  - **Inactive Slot (e.g., Green):** Used for deploying and validating new changes without affecting production users.

- **Deployment Flow:**  
  1. Deploy the new application version to the **Inactive Slot**.  
  2. Run health checks on the Inactive Slot to ensure the application is stable and functioning correctly.  
  3. If all checks pass, swap the Inactive Slot into production, making it the new Active Slot.  
  4. If checks fail, revert and avoid impacting the currently running environment.

## Repository Structure


- **azure-pipelines.yml:**  
  Defines a pipeline that logs into Azure, runs the deployment script, and swaps slots upon success.
  
- **deploy-blue-green.ps1:**  
  Performs the deployment steps. This script deploys code to the Inactive Slot, runs health checks, and signals success or failure back to the pipeline.
  
- **webapp-settings.json:**  
  Holds configuration values such as the deployment package URL or other deploy-time settings.

## Prerequisites

- **Azure CLI or PowerShell Az Module:**  
  Ensure you have these tools installed locally if you plan to run scripts directly. The pipeline itself uses these tools through Azure DevOps agents.
  
- **Azure DevOps Service Connection:**  
  The pipeline references a service connection in `azure-pipelines.yml` that must be configured in Azure DevOps to authenticate and deploy to your Azure environment.

- **Two Deployment Slots on Azure Web App:**  
  Make sure your Web App has at least one additional slot (other than the production slot) to implement Blue-Green deployments.

## How to Use

1. **Setup Service Connection:**  
   In Azure DevOps, create a service connection with sufficient permissions to your Azure Subscription and Resource Group.

2. **Configure Variables in azure-pipelines.yml:**  
   Update `resourceGroupName`, `webAppName`, and the slot names as needed. Ensure the `packageUrl` in `webapp-settings.json` points to a valid deployment package (e.g., a zipped application artifact).

3. **Run Pipeline:**  
   When you commit changes to the repository’s `main` branch, the pipeline triggers automatically. It deploys the application to the Inactive Slot, performs health checks, and if successful, swaps slots.

4. **Monitoring and Logs:**  
   - Check pipeline logs in Azure DevOps to see deployment progress and health check results.  
   - If health checks fail, the pipeline stops, preventing slot swapping and leaving the current production slot untouched.

## Customization

- **Health Check Endpoint:**  
  By default, the script uses `https://<appname>-<slot>.azurewebsites.net/health`. You can modify this in the `deploy-blue-green.ps1` script to point to a custom health endpoint or root path.

- **Rollback Logic:**  
  Currently, if health checks fail, the script simply exits with an error. You can extend this logic to redeploy a known-good artifact, send notifications, or integrate with issue tracking systems.

## License

This project is licensed under the [MIT License](../LICENSE).

---

**Enjoy reliable, zero-downtime deployments to Azure Web Apps!**
