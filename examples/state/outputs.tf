output "resource_group" {
  value       = azurerm_resource_group.rg.name
  description = "The name of the resource group in use."
}

output "storage_account_name" {
  value       = module.tfstate_module.storage_account_name
  description = "Storage account name where state files are stored."
}

output "storage_container_name" {
  value       = module.tfstate_module.storage_container_name
  description = "The name of the storage container for Terraform state files."
}

output "state_file_endpoint" {
  value       = module.tfstate_module.state_file_url
  description = "The URL of the state file in Azure Blob Storage."
}