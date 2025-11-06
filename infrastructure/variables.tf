variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-lbg-demo-dev"
}

variable "location" {
  description = "The Azure region to deploy to"
  type        = string
  default     = "Central US"
}

variable "environment" {
  description = "The environment (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
  default     = "acrlbgdemodev2025"
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
  default     = "lbg-aks-cluster"
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "vnet-dev-lbg-app"
}

variable "public_ip_name" {
  description = "The name of the public IP address for the load balancer"
  type        = string
  default     = "pip-lb-dev-lbg-app"
}

variable "vm_size" {
  description = "The size of the VMs in the AKS cluster"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "kubernetes_version" {
  description = "The Kubernetes version"
  type        = string
  default     = "1.33.3"
}

variable "min_count" {
  description = "Minimum number of nodes for auto-scaling"
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Maximum number of nodes for auto-scaling"
  type        = number
  default     = 5
}
