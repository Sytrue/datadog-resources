variable "environment" {
  description = "Environment name (e.g., uat, prod)"
  type        = string
}

variable "bckc_url" {
  description = "BCKC TrueCost URL"
  type        = string
  default     = "bckc-uat.claimlogiq.com"
}

variable "teams_channel" {
  description = "Teams channel for notifications"
  type        = string
  default     = "@teams-BCKC-Outages"
}

variable "teams_email" {
  description = "Teams email for notifications"
  type        = string
  default     = "@29e0b7c6.apixio.com@amer.teams.ms"
}

variable "monitor_name" {
  description = "Base name for the monitor"
  type        = string
  default     = "high-cpu-usage"
}

variable "alert_message" {
  description = "Alert message to be sent"
  type        = string
  default     = "CPU usage is too high"
}

variable "threshold" {
  description = "Alert threshold value"
  type        = number
  default     = 80
}

variable "additional_tags" {
  description = "Additional tags to add to resources"
  type        = list(string)
  default     = []
}
