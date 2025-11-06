# Outputs for existing resources
output "resource_group_name" {
  value = data.azurerm_resource_group.existing.name
}

output "storage_account_name" {
  value = data.azurerm_storage_account.existing.name
}

output "acr_login_server" {
  value = data.azurerm_container_registry.existing.login_server
}

output "acr_admin_username" {
  value = data.azurerm_container_registry.existing.admin_username
}

# Outputs for created resources
output "aks_cluster_name" {
  value = module.aks.name
}

output "aks_cluster_id" {
  value = module.aks.id
}

output "public_ip_address" {
  value = azurerm_public_ip.pip.ip_address
}

output "vnet_id" {
  value = module.network.vnet_id
}

output "subnet_id" {
  value = module.network.aks_subnet_id
}

output "kube_config" {
  value     = module.aks.kube_config
  sensitive = true
}
