resource "azurerm_resource_group" "laroa" {
  name     = "laroa"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "laroa" {
  name                = "laroa"
  location            = azurerm_resource_group.laroa.location
  resource_group_name = azurerm_resource_group.laroa.name
  dns_prefix          = "laroa" 

  default_node_pool {
    name           = "nodes"
    node_count     = 2
    vm_size        = "Standard_D2_v3"
    
  }

  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = var.ssh_key
    }
  }

  identity {
    type = "SystemAssigned"
  }
}
