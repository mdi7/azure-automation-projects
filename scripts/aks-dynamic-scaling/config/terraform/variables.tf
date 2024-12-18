variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group containing the AKS cluster."
}

variable "cluster_name" {
  type        = string
  description = "The name of the AKS cluster."
}

variable "node_count" {
  type        = number
  description = "The desired node count for the AKS cluster's node pool."
  default     = 1
}
