# Datadog Infrastructure as Code

This project manages Datadog resources using Terraform, with credentials securely stored in Azure Key Vault.

## Project Structure
```
.
├── base/                      # Base infrastructure
│   ├── main.tf               # Key Vault and core resources
│   ├── providers.tf          # Azure provider configuration
│   └── variables.tf          # Base variables
├── modules/
│   └── datadog/              # Datadog resource module
│       ├── README.md         # Module documentation
│       ├── main.tf           # Module resources
│       ├── variables.tf      # Module variables
│       └── outputs.tf        # Module outputs
└── environments/             # Environment-specific configurations
    ├── uat/                  # UAT environment
    │   └── main.tf          # UAT configuration
    └── prod/                 # Production environment
        └── main.tf          # PROD configuration
```

## Environments
This infrastructure supports two environments:
1. UAT (User Acceptance Testing)
2. PROD (Production)

Each environment has its own:
- State file
- Configuration
- Monitoring thresholds
- Alert settings

## Initial Setup

### 1. Azure Infrastructure
```