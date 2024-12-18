output "cluster_name" {
  description = "The name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.name
}

output "cluster_id" {
  description = "The resource ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.id
}

output "node_pool_name" {
  description = "The name of the AKS node pool."
  value       = azurerm_kubernetes_cluster_node_pool.default_pool.name
}

output "current_node_count" {
  description = "The current node count of the default node pool."
  value       = azurerm_kubernetes_cluster_node_pool.default_pool.node_count
}
