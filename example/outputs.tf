output "resource_group_name" {
  description = "The name of the resource group containing the storage account."
  value       = module.website_module.resource_group_name
}

output "storage_account_name" {
  description = "The name of the Azure Storage Account."
  value       = module.website_module.storage_account_name
}

output "index_blob_url" {
  description = "The URL of the index.html blob."
  value       = module.website_module.index_blob_url
}