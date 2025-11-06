terraform {
  required_version = ">= 1.0"
  
  backend "azurerm" {
    resource_group_name  = "rg-lbg-demo-dev"
    storage_account_name = "tfstatestorageacc2b22"
    container_name       = "lbg-02-12-1994"
    key                  = "terraform.tfstate"
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

# Get current service principal (the one running Terraform)
data "azurerm_client_config" "current" {}

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

# Data source for existing Public IP
data "azurerm_public_ip" "existing" {
  name                = "pip-lb-dev-lbg-app"
  resource_group_name = data.azurerm_resource_group.existing.name
}

# Data source for existing VNet
data "azurerm_virtual_network" "existing" {
  name                = "vnet-dev-lbg-app"
  resource_group_name = data.azurerm_resource_group.existing.name
}

# Data source for existing Subnet
data "azurerm_subnet" "existing" {
  name                 = "aks-subnet"
  virtual_network_name = data.azurerm_virtual_network.existing.name
  resource_group_name  = data.azurerm_resource_group.existing.name
}

# AKS Cluster Module - Create new cluster
module "aks" {
  source = "./modules/aks"

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  aks_cluster_name    = var.aks_cluster_name
  vnet_id             = data.azurerm_virtual_network.existing.id
  subnet_id           = data.azurerm_subnet.existing.id
  acr_id              = data.azurerm_container_registry.existing.id
  environment         = var.environment
  vm_size             = var.vm_size
  kubernetes_version  = var.kubernetes_version
  min_count           = var.min_count
  max_count           = var.max_count
}

# Kubernetes Provider
provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}

# Helm Provider
provider "helm" {
  kubernetes {
    host                   = module.aks.host
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
}
