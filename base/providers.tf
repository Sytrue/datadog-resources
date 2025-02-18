# Configure Azure Provider
provider "azurerm" {
  features {}
  use_cli = true
  subscription_id = "cc7e42fb-6f61-4086-9429-b0b5aeee13a2"
}

# Configure Terraform Backend
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    subscription_id      = "cc7e42fb-6f61-4086-9429-b0b5aeee13a2"
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "clqddtfstate"
    container_name      = "terraform-states"
    key                 = "base/terraform.tfstate"
    use_azuread_auth    = true
  }
} 