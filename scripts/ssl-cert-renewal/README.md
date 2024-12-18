# Automated SSL Certificate Renewal with Key Vault and Let’s Encrypt

This project automates the process of requesting, verifying, and renewing SSL certificates using Let’s Encrypt. After obtaining or renewing certificates, it stores them in Azure Key Vault and applies them to an Application Gateway or Azure Web App, ensuring your TLS endpoints remain secure and up-to-date.

## Features

- **Automated Renewal:**  
  Schedule a pipeline run (e.g., monthly) to request and renew certificates without manual intervention.
  
- **Integration with Key Vault:**  
  Certificates are securely stored in Azure Key Vault, ensuring centralized management of SSL secrets.

- **Application Gateway or Web App Updates:**  
  Automatically updates the SSL certificate binding on your Application Gateway or Azure Web App to use the newly obtained certificate.

## Directory Structure


sl-cert-renewal/ ├── azure-pipelines.yml # Azure DevOps pipeline for scheduled runs ├── renew-ssl.ps1 # Orchestrates the certificate request & upload process ├── scripts/ │ ├── get-letsencrypt-cert.sh # Uses Certbot or ACME client to get certificates │ └── export-cert-azure.ps1 # Optional: Convert cert/key to PFX if needed ├── config/ │ └── domains.json # Lists domains & emails to request certificates for └── README.md


## Prerequisites

- **Azure CLI Installed on Build Agent:**  
  Required for interacting with Key Vault, Application Gateway, or Web Apps.
  
- **Let’s Encrypt ACME Client (Certbot):**  
  Ensure Certbot or another ACME client is available to request and renew certificates.
  
- **Azure Key Vault & Application Gateway/Web App Set Up:**  
  Have an Azure Key Vault and Application Gateway/Web App resource ready, and ensure permissions allow updates.

## How It Works

1. **Configuration in domains.json:**  
   Add all the domains you want to manage. Each entry includes the domain name and an email for Let’s Encrypt registration and notifications.

2. **Pipeline Scheduling (azure-pipelines.yml):**  
   The pipeline is scheduled to run on the 1st of every month. Adjust the cron expression as needed.

3. **Script Execution (renew-ssl.ps1):**  
   - Invokes `get-letsencrypt-cert.sh` for each domain to retrieve or renew certificates.  
   - Converts the certificates into PFX format if needed and imports them into Key Vault.  
   - Updates Application Gateway or Web App SSL bindings to use the new certificate.

4. **DNS/HTTP Challenges:**  
   Adjust `get-letsencrypt-cert.sh` to handle DNS or HTTP challenges required by Let’s Encrypt. This might involve creating DNS TXT records or serving a validation file at a known endpoint.

## Customization

- **Alternative ACME Clients:**  
  Use a different ACME client or plugin suited to your DNS provider.

- **Enhanced Validation Steps:**  
  Add validations to ensure that new certificates are active and valid before updating your production endpoints.

- **Secret Rotation Notifications:**  
  Integrate notifications (e.g., Teams, Slack) to inform DevOps teams about successful renewals or failures.

## License

This project is licensed under the [MIT License](../LICENSE).

---

**Keep your endpoints secure and compliant without manual SSL certificate maintenance!**


