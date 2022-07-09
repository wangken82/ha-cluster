# Create network interfaces
resource "azurerm_network_interface" "sbd0" {
    name                      = "sbd0-nic"
    location                  = var.region
    resource_group_name       = azurerm_resource_group.myrg.name

    ip_configuration {
        name                          = "sbd0-private"
        subnet_id                     = azurerm_subnet.mysubnet.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.0.17"
        primary                       = "true"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "sbd0" {
    network_interface_id      = azurerm_network_interface.sbd0.id
    network_security_group_id = azurerm_network_security_group.ssh.id
}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "sbd0" {
    name                  = "sbd0-vm"
    location              = var.region
    resource_group_name   = azurerm_resource_group.myrg.name
    network_interface_ids = [azurerm_network_interface.sbd0.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "sbd0-osdisk"
        caching           = "ReadWrite"
        #disk_size_gb      = "128"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "SUSE"
        offer     = "sles-sap-12-sp5"
        sku       = "gen2"
        version   = "latest"
    }

    computer_name  = "sbd0"
    admin_username = "azureadmin"
#    custom_data    = file("<path/to/file>")

    admin_ssh_key {
        username       = "azureadmin"
        public_key     = file("~/.ssh/lab_rsa.pub")
    }
}

