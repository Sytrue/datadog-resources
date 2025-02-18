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
