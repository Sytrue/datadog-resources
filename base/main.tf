# Create Azure Key Vault
resource "azurerm_key_vault" "datadog_vault" {
  name                        = "CLQ-KeyVault-DevOps-East"  # Use existing Key Vault
  resource_group_name         = var.resource_group_name
  location                    = "eastus"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  
  # Security settings
  public_network_access_enabled = false
  network_acls {
    bypass                     = "AzureServices"
    default_action            = "Deny"
    ip_rules                  = [
      "71.235.215.47/32",
      "20.51.0.0/16",
      "20.75.0.0/16"
    ]
  }

  purge_protection_enabled    = true
  soft_delete_retention_days  = 90
  enable_rbac_authorization   = true
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
