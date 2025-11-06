output "resource_group_name" {
  value = module.resource_group.name
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "acr_admin_username" {
  value = module.acr.admin_username
}

output "aks_cluster_name" {
  value = module.aks.name
}

output "public_ip_address" {
  value = azurerm_public_ip.pip.ip_address
}

output "kube_config" {
  value     = module.aks.kube_config
  sensitive = true
}