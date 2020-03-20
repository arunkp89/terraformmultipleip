resource "azurerm_resource_group" "myterraformgroup" {
    name     = "myResourceGroup"
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
    address_prefix       = "10.0.0.0/24"
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
resource "azurerm_network_interface" "myterraformnic" {
    name                        = "myNIC"
    location                    = "eastus"
    resource_group_name         = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.11"
    public_ip_address_id          = "${azurerm_public_ip.myterraformpublicip.id}"
    primary                       = true
  }
  ip_configuration {
    name                          = "ipconfig2"
    subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.2"
  }
  ip_configuration {
    name                          = "ipconfig3"
    subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.3"
  }
  ip_configuration {
    name                          = "ipconfig4"
    subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.4"
  }
  ip_configuration {
    name                          = "ipconfig5"
    subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.5"
  }
  ip_configuration {
    name                          = "ipconfig6"
    subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.6"
  }
  ip_configuration {
    name                          = "ipconfig7"
    subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.7"
  }
  ip_configuration {
    name                          = "ipconfig8"
    subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.8"
  }
  ip_configuration {
    name                          = "ipconfig9"
    subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.9"
  }
  ip_configuration {
    name                          = "ipconfig10"
    subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.10"
  }
}
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.myterraformnic.id
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}
resource "azurerm_linux_virtual_machine" "myterraformvm" {
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
    admin_username = "azureuser"
    admin_password = "Password1234!"
    disable_password_authentication = false
 }
}
