variable "environment" {
  description = "Environment name (e.g., uat, prod)"
  type        = string
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

variable "bckc_host_name" {
  description = "BCKC host name for monitoring"
  type        = string
  default     = "bckc-truecost-uat-east-web"  # Default for UAT
}
