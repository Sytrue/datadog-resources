# Configure Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "cc7e42fb-6f61-4086-9429-b0b5aeee13a2"
}

# Configure Terraform Backend
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
    key                 = "uat/terraform.tfstate"
    use_azuread_auth    = true
  }
}

module "datadog_monitors" {
  source = "../../modules/datadog"

  environment     = "uat"
  monitor_name    = "high-cpu-usage"
  alert_message   = "UAT Environment: CPU usage is above threshold"
  threshold       = 85
  additional_tags = ["team:platform", "criticality:medium"]
}

# Update to only show CPU monitor details
output "cpu_monitor_details" {
  value = {
    id   = module.datadog_monitors.bckc_cpu_monitor_id
    name = module.datadog_monitors.bckc_cpu_monitor_name
  }
} 
# Test comment
