terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

# Get secrets from Key Vault
data "azurerm_key_vault" "datadog_vault" {
  name                = "clq-datadog-kv"
  resource_group_name = "rg-terraform-state"
}

data "azurerm_key_vault_secret" "dd_api_key" {
  name         = "datadog-api-key"
  key_vault_id = data.azurerm_key_vault.datadog_vault.id
}

data "azurerm_key_vault_secret" "dd_app_key" {
  name         = "datadog-app-key"
  key_vault_id = data.azurerm_key_vault.datadog_vault.id
}

# Configure the Datadog provider
provider "datadog" {
  api_key = data.azurerm_key_vault_secret.dd_api_key.value
  app_key = data.azurerm_key_vault_secret.dd_app_key.value
}

# BCKC UAT CPU Monitor
resource "datadog_monitor" "bckc_uat_cpu" {
  name    = "BCKC - UAT - TRUECOST - CPU Usage Alert"
  type    = "metric alert"
  message = <<EOF
{{#is_alert}}
🔥🔥🔥
## **HIGH CPU USAGE DETECTED!**
### **Issue:** High CPU utilization on BCKC UAT TrueCost server

**Metrics:**
- CPU Usage: {{value}}%
- Host: {{host.name}}
- Environment: UAT

### **⚠️ Impact:** This may affect TrueCost performance

@teams-BCKC-Outages
{{/is_alert}}

{{#is_recovery}}
## **CPU Usage Normalized**
- Current Usage: {{value}}%
- Host: {{host.name}}
- Environment: UAT

System has returned to normal operation.

@teams-BCKC-Outages
{{/is_recovery}}
EOF

  query = "avg(last_5m):avg:system.cpu.user{host:bckc-uat.claimlogiq.com} + avg:system.cpu.system{host:bckc-uat.claimlogiq.com} > 80"

  monitor_thresholds {
    critical          = 80  # Alert when CPU > 80%
    warning           = 70  # Warning when CPU > 70%
    critical_recovery = 75  # Recover critical when CPU < 75%
    warning_recovery  = 65  # Recover warning when CPU < 65%
  }

  # Evaluation Settings
  evaluation_delay    = 60
  notify_no_data     = true
  no_data_timeframe  = 10
  renotify_interval  = 30
  require_full_window = false
  include_tags       = true

  tags = [
    "env:uat",
    "managed-by:terraform",
    "application:truecost",
    "url:bckc-uat.claimlogiq.com",
    "monitor:cpu"
  ]
}
