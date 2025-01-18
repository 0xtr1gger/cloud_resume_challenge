variable "resource_group_name" {
  type        = string
  description = "Name for the Azure Resource Group."
  default     = "rg-cloud-resume-challenge"
}

variable "rg_location" {
  type        = string
  description = "Azure region for the resource group."
  default     = "East US"
}

variable "storage_account_name" {
  type        = string
  description = "Name for the Azure Storage Account."
  default     = "unique-azure-storage-account-name"
}

variable "storage_account_tier" {
  type        = string
  description = "Account tier for the storage account."
  default     = "Standard"
}

variable "storage_account_replication_type" {
  type        = string
  description = "Replication type for the storage account."
  default     = "LRS"
}

variable "index_document" {
  type        = string
  description = "Name of the index document of the static website."
  default     = "index.html"
}

variable "error_document" {
  type        = string
  description = "Name of the error document of the static website."
  default     = "index.html"
}

variable "styles" {
  type        = string
  description = "CSS for the index of the static website."
  default     = "styles.css"
}

variable "storage_container_name" {
  type        = string
  description = "Name of the Azure Blob storage container."
  default     = "web"
}