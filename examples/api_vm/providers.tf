terraform {
  required_version = ">=1.0"
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = ">= 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-cloud-resume-example"
    storage_account_name = "remotetfstaten1gbz8ln"
    container_name       = "terraform-state"
    key                  = "terraform.vm_tfstate"
  }
}


provider "azapi" {

}

provider "azurerm" {
  features {}
}


