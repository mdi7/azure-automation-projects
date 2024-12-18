# Dynamic Scaling of AKS Clusters Based on Scheduled Workload

This project automates scaling of an Azure Kubernetes Service (AKS) cluster based on defined schedules or predictive analytics. By increasing node counts during business hours and reducing them after-hours, you can optimize cost and performance.

## Features

- **Scheduled Scaling:**  
  Define time windows during which the cluster scales up or down.

- **Azure CLI Integration:**  
  Uses `az aks scale` to adjust node counts directly, or you can integrate with Terraform/ARM for more controlled IaC updates.

- **Pipeline-Driven Automation:**  
  Uses Azure DevOps pipelines scheduled triggers to run the scaling script at specified times.

## Directory Structure

