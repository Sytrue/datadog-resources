# Datadog Infrastructure as Code

This project manages Datadog resources using Terraform, with credentials securely stored in Azure Key Vault.

## Project Structure
```
.
├── base/                      # Base infrastructure
│   ├── main.tf               # Key Vault and core resources
│   ├── providers.tf          # Azure provider configuration
│   ├── variables.tf          # Base variables
│   └── terraform.tfvars      # (gitignored) Secret values
├── modules/
│   └── datadog/              # Datadog resource module
│       ├── README.md         # Module documentation
│       ├── main.tf           # Module resources
│       ├── variables.tf      # Module variables
│       └── outputs.tf        # Module outputs
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