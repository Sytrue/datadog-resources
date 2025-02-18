variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
  default     = "clqddtfstate"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-terraform-state"
}

variable "datadog_api_key" {
  description = "Datadog API Key"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog APP Key"
  type        = string
  sensitive   = true
} 