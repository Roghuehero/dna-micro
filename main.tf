provider "azurerm" {
  features {}
  subscription_id = "9e789e4f-ff6e-4f16-8f84-4685a353235a"
}

resource "azurerm_resource_group" "aks_rg" {
  name     = "myAKSResourceGroup"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "myAKSCluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name

  dns_prefix = "myaksdns"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true  # Use this property instead of the block
}