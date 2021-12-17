provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.79.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "RG100"
    storage_account_name = "rg100store2021"
    container_name       = "tfstate"
    key                  = "terraform2.tfstate"
  }
}

resource "azurerm_resource_group" "rgtest100" {
  name     = "rgtest100"
  location = "southeastasia"
}

resource "azurerm_resource_group" "rgtest101" {
  name     = "rgtest101"
  location = "southeastasia"
}

resource "azurerm_resource_group" "rgtest102" {
  name     = "rgtest102"
  location = "southeastasia"
}

resource "azurerm_resource_group" "rgtest103" {
  name     = "rgtest103"
  location = "southeastasia"
}
