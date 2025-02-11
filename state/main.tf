# state/main.tf

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
  source               = "../modules/remote-tfstate"
  storage_account_name = format("remotetfstate%s", random_string.storage_account_suffix.result)
}