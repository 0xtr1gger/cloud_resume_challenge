# example/main.tf

terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-cloud-resume-example"
    storage_account_name = "remotetfstaten1gbz8ln"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
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

module "website_module" {
  source               = "../modules/static-website"
  resource_group_name  = "rg-cloud-resume-example"
  storage_account_name = format("cloudresume%s", random_string.storage_account_suffix.result)

}
