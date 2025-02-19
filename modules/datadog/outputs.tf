# CPU Monitor outputs
output "bckc_cpu_monitor_id" {
  description = "ID of the BCKC UAT CPU monitor"
  value       = datadog_monitor.bckc_uat_cpu.id
}

output "bckc_cpu_monitor_name" {
  description = "Name of the BCKC UAT CPU monitor"
  value       = datadog_monitor.bckc_uat_cpu.name
}
