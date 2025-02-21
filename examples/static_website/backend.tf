terraform {
  backend "azurerm" {
    resource_group_name  = "rg-cloud-resume-example"
    storage_account_name = "remotetfstaten1gbz8ln"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}