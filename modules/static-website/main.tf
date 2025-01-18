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
  name     = var.resource_group_name # "rg-cloud-resume-challenge"
  location = var.rg_location         # "East US"
}

resource "azurerm_storage_account" "blob_storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.storage_account_tier             # "Standard"
  account_replication_type = var.storage_account_replication_type # "LRS"
}


resource "azurerm_storage_account_static_website" "static_website" {
  storage_account_id = azurerm_storage_account.blob_storage.id
  index_document     = var.index_document # "index.html"
  error_404_document = var.error_document # "index.html"
}

resource "azurerm_storage_container" "container" {
  name                  = var.storage_container_name # web
  storage_account_name  = azurerm_storage_account.blob_storage.name
  container_access_type = "container"
}

resource "azurerm_storage_blob" "index_blob" {
  name                   = var.index_document # index.html
  storage_account_name   = azurerm_storage_account.blob_storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = local.index_filepath # "${path.module}/../../src/static/index.html"
  content_type           = "text/html"
  content_md5            = md5(file(local.index_filepath))
}

resource "azurerm_storage_blob" "styles_blob" {
  name                   = var.styles # styles.css
  storage_account_name   = azurerm_storage_account.blob_storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = local.styles_filepath # "${path.module}/../../src/static/styles.css"
  content_type           = "text/css"
  content_md5            = md5(file(local.styles_filepath))
}

locals {
  source_path     = "${path.module}/../../src/static/"
  styles_filepath = "${local.source_path}${var.styles}"
  index_filepath  = "${local.source_path}${var.index_document}"
}
