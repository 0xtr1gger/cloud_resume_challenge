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

variable "source_code_path" {
  type        = string
  description = "Relative path to the directory with static files for the website."
  default     = "../src/static/"
}

variable "blobs" {
  type = map(object({
    name         = string
    content_type = string
  }))
  description = "The map of static files to be uploaded to the static website. Each element in the map should specify the name of the file (as in the source_code_path directory) and its content type."
  default = {
    index = {
      name         = "index.html"
      content_type = "text/html"
    }
    styles = {
      name         = "styles.css"
      content_type = "text/css"
    }
  }
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

variable "storage_container_name" {
  type        = string
  description = "The name of the Azure Blob storage container."
  default     = "web"
}
