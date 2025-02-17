output "public_ip_address" {
  value       = module.vm_module.public_ip_address
  description = "The IP address of the provisioned VM."
}

output "resource_group_name" {
  value       = module.vm_module.public_ip_address
  description = "The name of the resource group where the resources reside."
}

output "hostname" {
  value       = module.vm_module.vm_hostname
  description = "The hostname of the API server VM."
}
