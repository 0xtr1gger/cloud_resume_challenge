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

locals {
  source_path = "${path.module}/../../src/static/"

  blobs = {
    index = {
      name         = var.index_document # index.html
      source       = "${local.source_path}${var.index_document}"
      content_type = "text/html"
    }
    styles = {
      name         = var.styles # styles.css
      source       = "${local.source_path}${var.styles}"
      content_type = "text/css"
    }
  }
}

resource "azurerm_storage_blob" "blobs" {
  for_each               = local.blobs
  name                   = each.value.name
  storage_account_name   = azurerm_storage_account.blob_storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = each.value.source
  content_type           = each.value.content_type
  content_md5            = md5(file(each.value.source))
}