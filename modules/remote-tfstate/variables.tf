variable "storage_account_name" {
  type        = string
  description = "The unique name for the Azure Storage Account."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure resource group to create."
  default     = "rg-cloud-resume-example"
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