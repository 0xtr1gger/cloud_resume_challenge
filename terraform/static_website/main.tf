terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-cloud-resume-challenge"
  location = "East US"
}

resource "azurerm_storage_account" "blob_storage" {
  name                     = var.azure_storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_account_static_website" "static_website" {
  storage_account_id = azurerm_storage_account.blob_storage.id
  index_document     = "index.html"
  error_404_document = "index.html"
}

resource "azurerm_storage_container" "container" {
  name                  = "web"
  storage_account_name  = azurerm_storage_account.blob_storage.name
  container_access_type = "container"
}

resource "azurerm_storage_blob" "index_blob" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.blob_storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "${path.module}/../../src/static/index.html"
  content_type           = "text/html"
	content_md5            = md5(file("${path.module}/../../src/static/index.html"))
}

resource "azurerm_storage_blob" "styles_blob" {
  name                   = "styles.css"
  storage_account_name   = azurerm_storage_account.blob_storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "${path.module}/../../src/static/styles.css"
	content_type					 = "text/css"
	content_md5            = md5(file("${path.module}/../../src/static/styles.css"))
}
