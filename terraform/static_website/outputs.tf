output "resource_group_name" {
  description = "The name of the resource group containing the storage account."
  value       = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  description = "The name of the Azure Storage Account."
  value       = azurerm_storage_account.blob_storage.name
}

output "storage_account_primary_web_endpoint" {
  description = "The primary web endpoint for the static website."
  value       = azurerm_storage_account.blob_storage.primary_web_endpoint
}

output "storage_container_name" {
  description = "The name of the storage container for static files."
  value       = azurerm_storage_container.container.name
}

output "index_blob_url" {
  description = "The URL of the index.html blob."
  value       = "${azurerm_storage_account.blob_storage.primary_web_endpoint}${azurerm_storage_container.container.name}/index.html"
}
