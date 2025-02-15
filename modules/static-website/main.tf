resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name # "rg-cloud-resume-challenge"
  location = var.rg_location         # "East US"
}

resource "azurerm_storage_account" "blob_storage" {
  name                     = var.storage_account_name
  account_tier             = var.storage_account_tier             # "Standard"
  account_replication_type = var.storage_account_replication_type # "LRS"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}


resource "azurerm_storage_account_static_website" "static_website" {
  index_document     = var.index_document # "index.html"
  error_404_document = var.error_document # "index.html"

  storage_account_id = azurerm_storage_account.blob_storage.id
}

resource "azurerm_storage_container" "container" {
  name                  = var.storage_container_name # web
  container_access_type = "container"

  storage_account_name = azurerm_storage_account.blob_storage.name
}

resource "azurerm_storage_blob" "blobs" {
  for_each     = var.blobs
  name         = each.value.name
  source       = "${var.source_code_path}${each.value.name}"
  content_type = each.value.content_type
  content_md5  = md5(file("${var.source_code_path}${each.value.name}"))
  type         = "Block"

  storage_account_name   = azurerm_storage_account.blob_storage.name
  storage_container_name = azurerm_storage_container.container.name
}