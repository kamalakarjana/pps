output "name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "id" {
  description = "The ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.id
}

output "kube_config" {
  description = "The kubeconfig for the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "host" {
  description = "The Kubernetes cluster server host"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].host
  sensitive   = true
}

output "client_key" {
  description = "Base64 encoded public key used by clients to authenticate to the cluster"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_key
  sensitive   = true
}

output "client_certificate" {
  description = "Base64 encoded public certificate used by clients to authenticate to the cluster"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Base64 encoded public CA certificate used as the root of trust for the cluster"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
  sensitive   = true
}

output "kubelet_identity" {
  description = "The kubelet identity of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.kubelet_identity[0]
}
