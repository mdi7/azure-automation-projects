terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "resource_group_name" {}
variable "cluster_name" {}
variable "node_count" {}

resource "azurerm_kubernetes_cluster_node_pool" "default_pool" {
  name                  = "default"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_DS2_v2"
  node_count            = var.node_count
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
  location            = "East US"
  dns_prefix          = "myaks"
  default_node_pool {
    name       = "default"
    vm_size    = "Standard_DS2_v2"
    node_count = var.node_count
  }
  identity {
    type = "SystemAssigned"
  }
}
