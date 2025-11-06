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

output "public_ip_address" {
  value = data.azurerm_public_ip.existing.ip_address
}

output "vnet_id" {
  value = data.azurerm_virtual_network.existing.id
}

output "subnet_id" {
  value = data.azurerm_subnet.existing.id
}

# Outputs for created resources
output "aks_cluster_name" {
  value = module.aks.name
}

output "aks_cluster_id" {
  value = module.aks.id
}

output "kube_config" {
  value     = module.aks.kube_config
  sensitive = true
}
