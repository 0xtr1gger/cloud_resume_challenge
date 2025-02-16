output "resource_group_name" {
  description = "The name of the resource group containing the storage account."
  value       = var.resource_group_name
}

output "storage_account_name" {
  description = "The name of the Azure Storage Account."
  value       = azurerm_storage_account.blob_storage.name
}

output "storage_container_name" {
  description = "The name of the storage container for the remoate state file."
  value       = azurerm_storage_container.terraform_state.name
}

output "state_file_url" {
  description = "The URL of the remote Terraform state file."
  value       = "${azurerm_storage_account.blob_storage.primary_web_endpoint}${azurerm_storage_container.terraform_state.name}/terraform.tfstate"
}

