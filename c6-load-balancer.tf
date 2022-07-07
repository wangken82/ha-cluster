resource "azurerm_lb" "lb" {
  name                = "nfs-LoadBalancer"
  location            = var.region
  resource_group_name = azurerm_resource_group.myrg.name
#  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "nw1-frontend"
    private_ip_address   = "10.0.0.4"
    private_ip_address_allocation = "Static"
    subnet_id            = azurerm_subnet.mysubnet.id
  }

  frontend_ip_configuration {
    name                 = "nw2-frontend"
    private_ip_address   = "10.0.0.5"
    private_ip_address_allocation = "Static"
    subnet_id            = azurerm_subnet.mysubnet.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "nw-backend"
}

resource "azurerm_network_interface_backend_address_pool_association" "lb-0" {
  network_interface_id    = azurerm_network_interface.nfs-0.id
  ip_configuration_name   = "nfs-0-private"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb.id
}
resource "azurerm_network_interface_backend_address_pool_association" "lb-1" {
  network_interface_id    = azurerm_network_interface.nfs-1.id
  ip_configuration_name   = "nfs-1-private"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb.id
}

resource "azurerm_lb_probe" "lb-nw1" {
  resource_group_name = azurerm_resource_group.myrg.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "nw1-hp"
  port                = "61000"
  interval_in_seconds = "5"
  number_of_probes    = "2"
  protocol            = "Tcp"
}
resource "azurerm_lb_probe" "lb-nw2" {
  resource_group_name = azurerm_resource_group.myrg.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "nw2-hp"
  port                = "61001"
  interval_in_seconds = "5"
  number_of_probes    = "2"
  protocol            = "Tcp"
}

resource "azurerm_lb_rule" "lb-0" {
  resource_group_name            = azurerm_resource_group.myrg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "nw1-lb-2049-0"
  protocol                       = "Tcp"
  frontend_port                  = 2049
  backend_port                   = 2049
  frontend_ip_configuration_name = "nw1-frontend"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb.id
  enable_floating_ip             = "true"
  idle_timeout_in_minutes        = "30"
  probe_id                       = azurerm_lb_probe.lb-nw1.id
}
resource "azurerm_lb_rule" "lb-1" {
  resource_group_name            = azurerm_resource_group.myrg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "nw1-lb-2049-1"
  protocol                       = "Udp"
  frontend_port                  = 2049
  backend_port                   = 2049
  frontend_ip_configuration_name = "nw1-frontend"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb.id
  enable_floating_ip             = "true"
  idle_timeout_in_minutes        = "30"
  probe_id                       = azurerm_lb_probe.lb-nw1.id
}
resource "azurerm_lb_rule" "lb-2" {
  resource_group_name            = azurerm_resource_group.myrg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "nw1-lb-2049-2"
  protocol                       = "Tcp"
  frontend_port                  = 2049
  backend_port                   = 2049
  frontend_ip_configuration_name = "nw2-frontend"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb.id
  enable_floating_ip             = "true"
  idle_timeout_in_minutes        = "30"
  probe_id                       = azurerm_lb_probe.lb-nw2.id
}
resource "azurerm_lb_rule" "lb-3" {
  resource_group_name            = azurerm_resource_group.myrg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "nw1-lb-2049-3"
  protocol                       = "Udp"
  frontend_port                  = 2049
  backend_port                   = 2049
  frontend_ip_configuration_name = "nw2-frontend"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb.id
  enable_floating_ip             = "true"
  idle_timeout_in_minutes        = "30"
  probe_id                       = azurerm_lb_probe.lb-nw2.id
}