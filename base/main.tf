# Get current Azure configuration
data "azurerm_client_config" "current" {}

#checkov:skip=CKV2_AZURE_32: "Private endpoint will be implemented in next security phase"
resource "azurerm_key_vault" "datadog_vault" {
  name                = "clq-datadog-kv"
  resource_group_name = var.resource_group_name
  location            = "eastus"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name           = "standard"

  # Add purge protection and soft delete
  purge_protection_enabled   = true
  soft_delete_retention_days = 7
  enable_rbac_authorization = true

  # Add network rules
  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = [
      "71.235.215.47/32",    # Your IP
      "20.51.0.0/16",        # GitHub Actions Azure
      "20.75.0.0/16"         # GitHub Actions Azure
    ]
  }
}

# Update secrets with expiration and content type
resource "azurerm_key_vault_secret" "datadog_api_key" {
  name            = "datadog-api-key"
  value           = var.datadog_api_key
  key_vault_id    = azurerm_key_vault.datadog_vault.id
  content_type    = "api-key"
  expiration_date = timeadd(timestamp(), "8760h")  # 1 year from creation
}

resource "azurerm_key_vault_secret" "datadog_app_key" {
  name            = "datadog-app-key"
  value           = var.datadog_app_key
  key_vault_id    = azurerm_key_vault.datadog_vault.id
  content_type    = "app-key"
  expiration_date = timeadd(timestamp(), "8760h")  # 1 year from creation
} 
