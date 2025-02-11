
resource "azurerm_storage_account" "blob_storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.rg_location
  account_tier             = var.storage_account_tier             # "Standard"
  account_replication_type = var.storage_account_replication_type # "LRS"

}

resource "azurerm_storage_container" "terraform_state" {
  name                  = "terraform-state"
  storage_account_name  = var.storage_account_name
  container_access_type = "private"
}