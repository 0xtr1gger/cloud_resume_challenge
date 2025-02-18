terraform {
  required_version = ">=1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source = "hashicorp/random"
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


