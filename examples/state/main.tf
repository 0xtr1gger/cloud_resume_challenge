# state/main.tf

resource "random_string" "storage_account_suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-cloud-resume-example"
  location = "East US"
}

module "tfstate_module" {
  source                 = "../../modules/remote-tfstate"
  tfstate_container_name = "terraform-state"
  resource_group_name    = "rg-cloud-resume-example"
  storage_account_name   = format("remotetfstate%s", random_string.storage_account_suffix.result)
}