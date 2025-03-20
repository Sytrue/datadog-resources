# Datadog Infrastructure as Code with Terraform

This project manages Datadog monitoring resources using Terraform, with credentials securely stored in Azure Key Vault and automated deployments through GitHub Actions.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Initial Setup](#initial-setup)
- [Environments](#environments)
- [Security](#security)
- [Workflows](#workflows)
- [Usage Guide](#usage-guide)

## Prerequisites

### Required Tools
- Terraform (v1.5.0 or later)
- Azure CLI
- Git
- GitHub account

### Required Access
- Azure Subscription with:
  - Ability to create/manage Storage Accounts
  - Access to Key Vault
  - Permissions to create Service Principals
- Datadog account with:
  - Admin access to create API/Application keys
  - Ability to create monitors

## Project Structure
```
.
├── .github/workflows/          # GitHub Actions workflows
│   ├── deploy.yml             # Production deployment workflow
│   └── pr-check.yml           # PR validation workflow
├── base/                      # Base infrastructure
<<<<<<< Updated upstream
│   ├── main.tf               # Key Vault and core resources
│   ├── providers.tf          # Azure provider configuration
│   ├── variables.tf          # Base variables
│   └── terraform.tfvars      # (gitignored) Secret values
=======
│   ├── main.tf               # Key Vault setup
│   ├── providers.tf          # Azure provider config
│   └── variables.tf          # Base variables
>>>>>>> Stashed changes
├── modules/
│   └── datadog/              # Datadog resource module
│       ├── main.tf           # Monitor definitions
│       ├── variables.tf      # Module variables
│       └── outputs.tf        # Module outputs
<<<<<<< Updated upstream
└── environments/             # Environment-specific configurations
    └── uat/                  # UAT environment
        └── main.tf           # UAT configuration
```

## Initial Setup

### 1. Azure Infrastructure
```bash
# Login to Azure
az login
az account set --subscription "CLQ Corp Access"

# Initialize base infrastructure
cd base
terraform init
terraform apply
```

This creates:
- Azure Storage Account for Terraform state
- Azure Key Vault for Datadog credentials
- Required access policies

### 2. Datadog Module
The module provides reusable Datadog resources:
- Monitors (CPU, Memory, etc.)
- Dashboards (coming soon)
- Alerts configuration (coming soon)

### 3. Environment Deployment
```bash
# Deploy to UAT
cd environments/uat
terraform init
terraform apply
```

## Security
- Credentials stored in Azure Key Vault
- No sensitive data in source control
- RBAC-based access control

## Testing
1. UAT Environment:
```bash
cd environments/uat
terraform plan    # Review changes
terraform apply   # Apply changes
```

2. Verify in Datadog:
- Check monitors in Datadog UI
- Verify correct environment tags
- Test alert thresholds

## GitHub Actions Pipeline
```yaml:.github/workflows/terraform.yml
name: 'Terraform'

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2

    - name: Azure Login
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1

    - name: Terraform Init
      run: |
        cd environments/uat
        terraform init

    - name: Terraform Plan
      run: |
        cd environments/uat
        terraform plan

    - name: Terraform Apply
      if: github.ref == 'refs/heads/main'
      run: |
        cd environments/uat
        terraform apply -auto-approve
```

## Adding New Resources
1. Add resource definition to `modules/datadog/main.tf`
2. Update module variables in `modules/datadog/variables.tf`
3. Update module documentation
4. Test in UAT environment
5. Create PR for review

## Maintenance
- Regularly rotate Datadog credentials
- Review and update alert thresholds
- Monitor Terraform state storage costs
=======
└── environments/             # Environment configurations
    ├── uat/                  # UAT environment
    │   └── main.tf          # UAT specific config
    └── prod/                 # Production environment
        └── main.tf          # PROD specific config
```

## Initial Setup

### 1. Azure Infrastructure Setup
```bash
# Login to Azure
az login

# Create Resource Group
az group create --name rg-terraform-state --location eastus

# Create Storage Account
az storage account create \
    --name clqddtfstate \
    --resource-group rg-terraform-state \
    --location eastus \
    --sku Standard_LRS

# Create Container
az storage container create \
    --name terraform-states \
    --account-name clqddtfstate
```

### 2. Azure Key Vault Setup
- Create Key Vault for storing Datadog credentials
- Store Datadog API and Application keys
- Configure access policies

### 3. GitHub Repository Setup
1. Create new repository
2. Configure branch protection:
   - Require PR reviews
   - Enable status checks
   - Protect main branch

### 4. GitHub Environments
Create two environments:
1. UAT Environment:
   - Required reviewers
   - Environment secrets
   - Deployment protection rules

2. PROD Environment:
   - Stricter approval requirements
   - Wait timer
   - Environment secrets

## Security

### Azure Authentication
The project uses Azure AD authentication with service principals:
```yaml
client-id: ${{ secrets.AZURE_CLIENT_ID }}
tenant-id: ${{ secrets.AZURE_TENANT_ID }}
subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

### Required Secrets
1. Repository Secrets:
   - AZURE_CLIENT_ID
   - AZURE_TENANT_ID
   - AZURE_SUBSCRIPTION_ID

2. Environment Secrets (UAT/PROD):
   - Same as repository secrets

## Workflows

### PR Check Workflow
Triggered on pull requests to main:
1. Validates Terraform configurations
2. Checks formatting
3. Runs security scans
4. Shows plan output for both environments

### Deploy Workflow
Triggered on push to main:
1. Deploys to UAT first
2. Requires approval
3. Deploys to PROD after approval

## Usage Guide

### Making Changes
1. Create new branch:
```bash
git checkout -b feature/your-feature
```

2. Make changes and commit:
```bash
git add .
git commit -m "Description of changes"
git push origin feature/your-feature
```

3. Create Pull Request:
   - PR triggers validation workflow
   - Get approvals
   - Merge to main

### Monitoring Deployments
1. Watch GitHub Actions:
   - PR check results
   - Deployment progress
2. Monitor in Datadog:
   - Check monitor status
   - Verify configurations

## Troubleshooting

### Common Issues
1. Authentication Failures:
   - Verify Azure credentials
   - Check service principal permissions

2. Terraform State Issues:
   - Verify storage account access
   - Check backend configuration

3. Workflow Failures:
   - Check environment secrets
   - Verify environment protection rules

## Contributing
1. Fork the repository
2. Create feature branch
3. Submit pull request
4. Get review and approval

## License
[Your License Here]
>>>>>>> Stashed changes
