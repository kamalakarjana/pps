resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.aks_cluster_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.aks_cluster_name}-${var.environment}"
  kubernetes_version  = var.kubernetes_version  # Use variable instead of hardcoded value

  default_node_pool {
    name                = "default"
    vm_size             = var.vm_size
    vnet_subnet_id      = var.subnet_id
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count           = var.min_count
    max_count           = var.max_count
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr   = "10.0.2.0/24"
    dns_service_ip = "10.0.2.10"
  }

  role_based_access_control_enabled = true

  tags = {
    environment = var.environment
  }
}

# Assign AKS the role to pull from ACR
resource "azurerm_role_assignment" "aks_acr" {
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}

# Output for kubeconfig
resource "local_file" "kubeconfig" {
  count    = var.environment == "dev" ? 1 : 0
  filename = "${path.root}/kubeconfig-${var.environment}"
  content  = azurerm_kubernetes_cluster.main.kube_config_raw
}