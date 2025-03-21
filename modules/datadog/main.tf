terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

# Get secrets from existing Key Vault
data "azurerm_key_vault" "datadog_vault" {
  name                = "CLQ-KeyVault-DevOps-East"
  resource_group_name = "rg-terraform-state"
}

data "azurerm_key_vault_secret" "dd_api_key" {
  name         = "datadog-underscore-api-underscore-key"
  key_vault_id = data.azurerm_key_vault.datadog_vault.id
}

data "azurerm_key_vault_secret" "dd_app_key" {
  name         = "datadog-underscore-app-underscore-key"
  key_vault_id = data.azurerm_key_vault.datadog_vault.id
}

# Configure the Datadog provider
provider "datadog" {
  api_key = data.azurerm_key_vault_secret.dd_api_key.value
  app_key = data.azurerm_key_vault_secret.dd_app_key.value
}

resource "datadog_monitor" "cpu_monitor" {
  name    = "${var.environment}-${var.monitor_name}"
  type    = "metric alert"
  message = var.alert_message

  query = format(
    "avg(last_5m):avg:system.cpu.user{environment:%s} > %d",
    var.environment,
    var.threshold
  )

  tags = concat(
    [
      "env:${var.environment}",
      "managed-by:terraform"
    ],
    var.additional_tags
  )
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

  query = "avg(last_5m):avg:system.cpu.user{name:${var.bckc_host_name}} + avg:system.cpu.system{name:${var.bckc_host_name}} > ${var.threshold}"

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

# Create the HTTP test
resource "datadog_synthetics_test" "bsc_http" {
  name    = "BSC - ${upper(var.environment)} - TRUECOST - HTTP Check"
  type    = "api"
  subtype = "http"
  
  request_definition {
    method = "GET"
    url    = "https://bsc-${var.environment}.claimlogiq.com"
  }
  
  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }
  
  locations = ["aws:us-east-1"]
  status    = "live"
  
  options_list {
    tick_every = 300
  }
}

# Then update the monitor to use this test
resource "datadog_monitor" "bsc_http_check" {
  name    = "BSC TEST - ${upper(var.environment)} - TRUECOST - HTTP CHECK"
  type    = "service check"
  message = <<EOF
{{#is_alert}}
🔥 **HTTP Check Failed**
### **Issue:** Cannot establish HTTP connection to BSC ${upper(var.environment)} TrueCost

**Details:**
- URL: https://bsc-${var.environment}.claimlogiq.com
- Environment: ${upper(var.environment)}
- Status: {{check_message}}

### **⚠️ Impact:** Service might be unreachable

# Notifications commented out for testing
#${var.teams_channel}
{{/is_alert}}

{{#is_recovery}}
✅ **HTTP Check Recovered**
- URL: https://bsc-${var.environment}.claimlogiq.com
- Environment: ${upper(var.environment)}
- Status: {{check_message}}

Service is now reachable.

# Notifications commented out for testing
#${var.teams_channel}
{{/is_recovery}}
EOF

  query = "synthetics.test.results{test_id:\"${datadog_synthetics_test.bsc_http.id}\"}.by(\"test_id\",\"location\").last(2).count_by_status()"

  monitor_thresholds {
    warning  = 2    # Warning after 2 failures
    critical = 3    # Critical after 3 failures
  }

  # Evaluation Settings
  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 30
  include_tags      = true

  tags = [
    "env:${var.environment}",
    "managed-by:terraform",
    "application:truecost",
    "url:bsc-${var.environment}.claimlogiq.com",
    "monitor:http"
  ]
}
