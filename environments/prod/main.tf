provider "azurerm" {
  features {}
  subscription_id = "cc7e42fb-6f61-4086-9429-b0b5aeee13a2"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "clqddtfstate"
    container_name      = "terraform-states"
    key                 = "prod/terraform.tfstate"
    use_azuread_auth    = true
  }
}

module "datadog_monitors" {
  source = "../../modules/datadog"
<<<<<<< Updated upstream

  environment     = "prod"
  monitor_name    = "high-cpu-usage"
  alert_message   = "PROD Environment: CPU usage is above threshold! Please investigate immediately."
  threshold       = 80  # More strict threshold for production
  additional_tags = ["team:platform", "criticality:high"]
=======
  environment = "prod"
  threshold = 80  # Stricter threshold
  # Other PROD-specific settings
>>>>>>> Stashed changes
} 