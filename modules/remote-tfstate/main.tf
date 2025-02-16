
resource "azurerm_storage_account" "blob_storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.rg_location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

}

resource "azurerm_storage_container" "terraform_state" {
  name                  = var.tfstate_container_name # "terraform-state"
  container_access_type = "private"
  storage_account_name  = var.storage_account_name
}