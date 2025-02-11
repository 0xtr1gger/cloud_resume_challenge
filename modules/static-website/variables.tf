variable "storage_account_name" {
  type        = string
  description = "The unique name for the Azure Storage Account."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure resource group to create."
  default     = "rg-cloud-resume-challenge"
}

variable "rg_location" {
  type        = string
  description = "The Azure region to deploy the resources."
  default     = "East US"
}

variable "storage_account_tier" {
  type        = string
  description = "The tier for the Azure storage account."
  default     = "Standard"
}

variable "storage_account_replication_type" {
  type        = string
  description = "The replication type for the storage account."
  default     = "LRS"
}

variable "index_document" {
  type        = string
  description = "The name of the index document for the static website."
  default     = "index.html"
}

variable "error_document" {
  type        = string
  description = "The name of the error document for the static website."
  default     = "index.html"
}

variable "styles" {
  type        = string
  description = "The name of the CSS file for the website."
  default     = "styles.css"
}

variable "storage_container_name" {
  type        = string
  description = "The name of the Azure Blob storage container."
  default     = "web"
}