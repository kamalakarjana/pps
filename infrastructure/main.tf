terraform {
  required_version = ">= 1.0"
  backend "azurerm" {
    resource_group_name  = "rg-lbg-demo-dev"
    storage_account_name = "tfstatestorageacc0212"
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

# Resource Group
module "resource_group" {
  source = "./modules/resource-group"

  resource_group_name = var.resource_group_name
  location            = var.location
  environment         = var.environment
}

# Container Registry
module "acr" {
  source = "./modules/acr"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  acr_name            = var.acr_name
  environment         = var.environment
}

# Network
module "network" {
  source = "./modules/network"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  vnet_name           = var.vnet_name
  environment         = var.environment
}

# AKS Cluster
module "aks" {
  source = "./modules/aks"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  aks_cluster_name    = var.aks_cluster_name
  vnet_id             = module.network.vnet_id
  subnet_id           = module.network.aks_subnet_id
  acr_id              = module.acr.id
  environment         = var.environment
  node_count          = var.node_count
  vm_size             = var.vm_size
  kubernetes_version  = var.kubernetes_version
}

# Public IP for Load Balancer
resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.environment}-lbg-ns"

  tags = {
    environment = var.environment
  }
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