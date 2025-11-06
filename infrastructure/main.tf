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

# Grant required roles to service principal at resource group level
resource "azurerm_role_assignment" "sp_contributor_rg" {
  scope                = data.azurerm_resource_group.existing.id
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Contributor"
}

resource "azurerm_role_assignment" "sp_user_access_admin_rg" {
  scope                = data.azurerm_resource_group.existing.id
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "User Access Administrator"
}

# Network Module - Create new VNet
module "network" {
  source = "./modules/network"

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  vnet_name           = var.vnet_name
  environment         = var.environment
}

# AKS Cluster Module - Create new cluster
module "aks" {
  source = "./modules/aks"

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  aks_cluster_name    = var.aks_cluster_name
  vnet_id             = module.network.vnet_id
  subnet_id           = module.network.aks_subnet_id
  acr_id              = data.azurerm_container_registry.existing.id
  environment         = var.environment
  vm_size             = var.vm_size
  kubernetes_version  = var.kubernetes_version
  min_count           = var.min_count
  max_count           = var.max_count
}

# Public IP for Load Balancer
resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "${var.environment}-lbg-app"

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
