# Create Azure Key Vault
resource "azurerm_key_vault" "datadog_vault" {
<<<<<<< Updated upstream
  name                = "clq-datadog-kv"
  resource_group_name = var.resource_group_name
  location            = "eastus"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name           = "standard"
=======
  name                        = "clq-datadog-kv"
  resource_group_name         = var.resource_group_name
  location                    = "eastus"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  
  # Fix for CKV_AZURE_109, CKV_AZURE_189
  public_network_access_enabled = false
  network_acls {
    bypass                     = "AzureServices"
    default_action            = "Deny"
    ip_rules                  = [
      "71.235.215.47/32",    # Your IP
      "20.51.0.0/16",        # GitHub Actions Azure
      "20.75.0.0/16"         # GitHub Actions Azure
    ]
    virtual_network_subnet_ids = []  # Required even if empty
  }
>>>>>>> Stashed changes

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

<<<<<<< Updated upstream
    secret_permissions = [
      "Get", "List", "Set", "Delete"
    ]
=======
  # Additional required settings
  enabled_for_disk_encryption = true
  enabled_for_deployment      = true
  enabled_for_template_deployment = true

  tags = {
    environment = "shared"
    managed_by  = "terraform"
>>>>>>> Stashed changes
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
