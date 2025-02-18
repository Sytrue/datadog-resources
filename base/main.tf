# Create Azure Key Vault
resource "azurerm_key_vault" "datadog_vault" {
  name                = "clq-datadog-kv"
  resource_group_name = var.resource_group_name
  location            = "eastus"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name           = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete"
    ]
  }
}

# Store Datadog secrets
resource "azurerm_key_vault_secret" "datadog_api_key" {
  name         = "datadog-api-key"
  value        = var.datadog_api_key
  key_vault_id = azurerm_key_vault.datadog_vault.id
}

resource "azurerm_key_vault_secret" "datadog_app_key" {
  name         = "datadog-app-key"
  value        = var.datadog_app_key
  key_vault_id = azurerm_key_vault.datadog_vault.id
}

# Get current Azure configuration
data "azurerm_client_config" "current" {} 
