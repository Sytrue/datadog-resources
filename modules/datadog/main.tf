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
resource "datadog_monitor" "bckc_cpu" {
  name    = "BCKC - ${upper(var.environment)} - TRUECOST - CPU Usage Alert"
  type    = "metric alert"
  message = <<EOF
{{#is_alert}}
🔥🔥🔥
## **HIGH CPU USAGE DETECTED!**
### **Issue:** High CPU utilization on BCKC ${upper(var.environment)} TrueCost server

**Metrics:**
- CPU Usage: {{value}}%
- Host: {{host.name}}
- Environment: ${upper(var.environment)}

### **⚠️ Impact:** This may affect TrueCost performance

# Notifications commented out for testing
#${var.teams_channel}
{{/is_alert}}

{{#is_recovery}}
## **CPU Usage Normalized**
- Current Usage: {{value}}%
- Host: {{host.name}}
- Environment: ${upper(var.environment)}

System has returned to normal operation.

# Notifications commented out for testing
#${var.teams_channel}
{{/is_recovery}}
EOF

  query = "avg(last_5m):avg:system.cpu.user{host:bckc-${var.environment}.claimlogiq.com} + avg:system.cpu.system{host:bckc-${var.environment}.claimlogiq.com} > ${var.threshold}"

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
    "env:${var.environment}",
    "managed-by:terraform",
    "application:truecost",
    "url:bckc-${var.environment}.claimlogiq.com",
    "monitor:cpu"
  ]
}
