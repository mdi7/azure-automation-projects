# Azure Automation Projects

Welcome to the **Azure Automation Projects** repository! This collection of scripts, templates, and pipelines is designed to streamline and automate complex tasks in Microsoft Azure environments. Whether you need blue-green deployments, dynamic scaling of Kubernetes clusters, or automated tag governance, you’ll find solutions and patterns here to simplify your operations.

## Projects Overview

1. **Blue-Green Deployment Orchestrator for Web Apps**  
   Automate zero-downtime deployments by alternating between Blue and Green slots, performing health checks, and managing rollbacks.

2. **Automated Azure Resource Tagging and Governance**  
   Ensure all resources are consistently tagged. Applies Azure Policies, runs compliance checks, and generates reports.

3. **Infrastructure as Code (IaC) Conversion Tool**  
   Convert ARM templates to Bicep or Terraform. Validate syntax, enforce standards, and manage version control.

4. **Dynamic Scaling of AKS Clusters**  
   Scale Kubernetes clusters based on time of day or predictive analytics, ensuring cost efficiency and performance.

5. **Automated SSL Certificate Renewal**  
   Integrate with Let’s Encrypt to automatically renew certificates stored in Key Vault and applied to your endpoints.

... (list all 30 projects with brief descriptions) ...

30. **Greenfield Environment Builder**  
   Deploy a brand-new environment, complete with networks, apps, databases, and monitoring, all defined via IaC.

## Getting Started

1. **Prerequisites:**
   - Azure CLI or PowerShell Az Module installed locally.
   - Appropriate Azure credentials with sufficient permissions.
   - Optional: Terraform and/or Bicep CLI if using IaC-based scripts.

2. **Setup:**
   - Clone this repository:  
     ```bash
     git clone https://github.com/yourusername/azure-automation-projects.git
     ```
   - Navigate to a project directory and review the `azure-pipelines.yml` or scripts.

3. **Usage:**
   - Run scripts directly from your terminal:
     ```powershell
     # Example for Blue-Green Deployment
     cd blue-green-deployment
     pwsh ./deploy-blue-green.ps1 -AppName "mywebapp" -ResourceGroup "myrg"
     ```

4. **CI/CD Integration:**
   - Each project includes a sample `azure-pipelines.yml` or equivalent GitHub Actions workflow for automated integration into your CI/CD process.

## Contributing

Contributions are welcome! Feel free to submit PRs or open issues to suggest improvements, report bugs, or request new features.

## License

This project is licensed under the [MIT License](LICENSE).

---

**Happy Automating!**
