resource "azurerm_resource_group" "salesforce" {
  name     = "salesforce"
  location = "southcentralus"
}
resource "azurerm_network_security_group" "salesforce" {

  name                = "nsg"
  location            = "${azurerm_resource_group.salesforce.location.id}"
  resource_group_name = "${azurerm_resource_group.salesforce.name}"
  security_rule {
    name                       = "allow-ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}
resource "azurerm_subnet_network_security_group_association" "salesforce" {
  subnet_id                 = "${azurerm_subnet.salesforce.id}"
  network_security_group_id = "${azurerm_network_security_group.salesforce.id}"
  depends_on = ["azurerm_subnet.salesforce"]

 }
 resource "azurerm_virtual_network" "salesforce" {
 name                = "vnet"
 address_space       = ["10.0.0.0/24"]
 location            = "${azurerm_resource_group.salesforce.location}"
 resource_group_name = "${azurerm_resource_group.salesforce.name}"
 depends_on          = ["azurerm_resource_group.salesforce"]
 }

resource "azurerm_subnet" "salesforce" {
 name                 = "subnet"
 resource_group_name  = "${azurerm_resource_group.salesforce.name}"
 virtual_network_name = "${azurerm_virtual_network.salesforce.name}"
 address_prefix       = "10.0.0.0/24"
}
resource "azurerm_public_ip" "salesforce" {
 name                         = "PUBLIC_IP_ADDRESS"
 location                     = "${azurerm_resource_group.salesforce.location}"
 resource_group_name          = "${azurerm_resource_group.salesforce.name}"
 allocation_method            = "Static"
 depends_on          = ["azurerm_resource_group.salesforce"]
 }
resource "azurerm_network_interface" "salesforce" {
  name                = "nic1"
  location                     = "${azurerm_resource_group.salesforce.location}"
  resource_group_name          = "${azurerm_resource_group.salesforce.name}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_subnet.salesforce.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.1"
    public_ip_address_id          = "${azurerm_public_ip.salesforce.id}"
    primary                       = true
  }
  ip_configuration {
    name                          = "ipconfig2"
    subnet_id                     = "${azurerm_subnet.salesforce.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.2"
  }
  ip_configuration {
    name                          = "ipconfig3"
    subnet_id                     = "${azurerm_subnet.salesforce.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.3"
  }
  ip_configuration {
    name                          = "ipconfig4"
    subnet_id                     = "${azurerm_subnet.salesforce.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.4"
  }
  ip_configuration {
    name                          = "ipconfig5"
    subnet_id                     = "${azurerm_subnet.salesforce.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.5"
  }
  ip_configuration {
    name                          = "ipconfig6"
    subnet_id                     = "${azurerm_subnet.salesforce.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.6"
  }
  ip_configuration {
    name                          = "ipconfig7"
    subnet_id                     = "${azurerm_subnet.salesforce.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.7"
  }
  ip_configuration {
    name                          = "ipconfig8"
    subnet_id                     = "${azurerm_subnet.salesforce.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.8"
  }
  ip_configuration {
    name                          = "ipconfig9"
    subnet_id                     = "${azurerm_subnet.salesforce.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.9"
  }
  ip_configuration {
    name                          = "ipconfig10"
    subnet_id                     = "${azurerm_subnet.salesforce.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.0.10"
  }
}
resource "azurerm_virtual_machine" "salesforce" {
  name                  = "vm-1"
  location              = "${azurerm_resource_group.salesforce.location}"
  resource_group_name   = "${azurerm_resource_group.salesforce.name}"
  network_interface_ids = "${azurerm_network_interface.salesforce.id}"
  vm_size               = "Standard_B2ms"
  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS-CI"
    sku       = "7-CI"
    version   = "7.7.20191209"
  }
  storage_os_disk {
    name              = "vm1osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "vm-1"
    admin_username = "azure"
    admin_password = "Password1234!"
  }
}
}