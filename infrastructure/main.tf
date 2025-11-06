terraform {
  required_version = ">= 1.0"
  backend "azurerm" {
    resource_group_name  = "rg-lbg-demo-dev"
    storage_account_name = "tfstatestorageacc2b22"
    container_name       = "lbg-02-12-1994"
    key                  = "terraform.lbg-02-12-1994"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Data sources for existing resources
data "azurerm_resource_group" "existing" {
  name = "rg-lbg-demo-dev"
}

data "azurerm_storage_account" "existing" {
  name                = "tfstatestorageacc2b22"
  resource_group_name = data.azurerm_resource_group.existing.name
}

data "azurerm_container_registry" "existing" {
  name                = "acrlbgdemodev2025"
  resource_group_name = data.azurerm_resource_group.existing.name
}

# ... rest of your main.tf ...