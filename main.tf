provider "azurerm" {
    version = "~>2.0"
    features {}
}

resource "azurerm_resource_group" "myterraformgroup" {
    name     = "salesforce"
    location = "eastus"
}

resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "myVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.myterraformgroup.name
}

resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "mySubnet"
    resource_group_name  = azurerm_resource_group.myterraformgroup.name
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefix       = "10.0.1.0/24"
}

resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "myPublicIP"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    allocation_method            = "Dynamic"
}
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "myNetworkSecurityGroup"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.myterraformgroup.name
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "myterraformnic" {
    name                      = "myNIC"
    location                  = "eastus"
    resource_group_name       = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "myNicConfiguration1"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.1.11"
        primary                       = true
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }

    ip_configuration {
        name                          = "myNicConfiguration2"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.1.12"
    }
    ip_configuration {
        name                          = "myNicConfiguration3"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.1.13"
    }
    ip_configuration {
        name                          = "myNicConfiguration4"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.1.14"
    }
    ip_configuration {
        name                          = "myNicConfiguration5"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.1.15"
    }
    ip_configuration {
        name                          = "myNicConfiguration6"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.1.16"
    }
    ip_configuration {
        name                          = "myNicConfiguration7"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.1.17"
    }
    ip_configuration {
        name                          = "myNicConfiguration8"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.1.18"
    }
    ip_configuration {
        name                          = "myNicConfiguration9"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.1.19"
    }
    ip_configuration {
        name                          = "myNicConfiguration10"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.1.20"
    }
}

resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.myterraformnic.id
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}
resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 120"
  }
  triggers = {
    "before" = "${null_resource.before.id}"
  }
}

resource "azurerm_linux_virtual_machine" "terraformvm" {
    name                  = "myVM"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.myterraformgroup.name
    network_interface_ids = [azurerm_network_interface.myterraformnic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "OpenLogic"
        offer     = "CentOS-CI"
        sku       = "7-CI"
        version   = "7.7.20191209"
    }

    computer_name  = "myvm"
    admin_username = "azure"
    admin_password = "Password1234!"
    disable_password_authentication = false
    
}