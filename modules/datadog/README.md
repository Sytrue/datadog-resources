# Datadog Module

This module manages Datadog resources using credentials stored in Azure Key Vault.

## Usage
```hcl
module "datadog_monitors" {
  source = "../../modules/datadog"

  environment     = "uat"
  monitor_name    = "high-cpu-usage"
  alert_message   = "CPU usage is above threshold"
  threshold       = 85
  additional_tags = ["team:platform"]
}
```

## Requirements
- Access to Azure Key Vault `clq-datadog-kv`
- Datadog API and APP keys stored in the vault

## Variables
| Name | Description | Type | Default |
|------|-------------|------|---------|
| environment | Environment name (e.g., uat, prod) | string | - |
| monitor_name | Base name for the monitor | string | "high-cpu-usage" |
| alert_message | Alert message to be sent | string | "CPU usage is too high" |
| threshold | Alert threshold value | number | 80 |
| additional_tags | Additional tags to add | list(string) | [] |
