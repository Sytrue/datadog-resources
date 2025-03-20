<<<<<<< Updated upstream
output "monitor_id" {
  description = "ID of the created monitor"
  value       = datadog_monitor.cpu_monitor.id
}

output "monitor_name" {
  description = "Name of the created monitor"
  value       = datadog_monitor.cpu_monitor.name
=======
# CPU Monitor outputs
output "bckc_cpu_monitor_id" {
  description = "ID of the BCKC CPU monitor"
  value       = datadog_monitor.bckc_cpu.id
}

output "bckc_cpu_monitor_name" {
  description = "Name of the BCKC CPU monitor"
  value       = datadog_monitor.bckc_cpu.name
>>>>>>> Stashed changes
}
