locals {
  my_fullprefix = "${var.prefix}-${var.env}"
}

# use custom image
data "azurerm_image" "mmproxy" {
  name                = var.custom_image_name
  resource_group_name = var.rg_name
}

resource "azurerm_network_security_group" "main" {
  name                = "${local.my_fullprefix}-${var.name}-nsg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "sshinbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "204.14.232.0/21"
    destination_address_prefix = "*"
  }
  //  tags = {
  //    environment = "Production"
  //  }
}

resource "azurerm_network_interface" "main" {
  name                      = "${local.my_fullprefix}-${var.name}-nic1"
  location                  = var.location
  resource_group_name       = var.rg_name
  enable_ip_forwarding      = true
  network_security_group_id = azurerm_network_security_group.main.id
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ip1"
    subnet_id                     = data.azurerm_subnet.subnet.id
    primary                       = true // one must be marked primary!
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.64.4"
    public_ip_address_id          = azurerm_public_ip.ip1.id
  }

  ip_configuration {
    name                          = "ip2"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.64.5"
    public_ip_address_id          = azurerm_public_ip.ip2.id
  }

  ip_configuration {
    name                          = "ip3"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.64.6"
    public_ip_address_id          = azurerm_public_ip.ip3.id
  }
}

resource "azurerm_virtual_machine" "vm1" {
  name                  = "${local.my_fullprefix}-${var.name}-1"
  location              = var.location
  zones                 = [1]
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_F16"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = data.azurerm_image.mmproxy.id
  }

  storage_os_disk {
    name              = "${local.my_fullprefix}-${var.name}-disk-1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.my_fullprefix}-${var.name}-1"
    admin_username = "testadmin"

    custom_data = <<CLOUDINIT
    #cloud-config
    package_update: true
    package_upgrade: true
    package_reboot_if_required: true
    CLOUDINIT

    //    custom_data = <<CLOUDINIT
    //    #cloud-config
    //    package_update: true
    //    package_upgrade: true
    //    package_reboot_if_required: true
    //    runcmd:
    //    - ip a add 10.0.64.4/18 dev eth0
    //    - ip a add 10.0.64.5/18 dev eth0
    //    - ip a add 10.0.64.6/18 dev eth0
    //    CLOUDINIT
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = file("~/.azure/ssh/id_rsa.pub")
      path     = "/home/testadmin/.ssh/authorized_keys"
    }
  }

  tags = {
    environment = "staging"
  }
}

resource "azurerm_virtual_machine_extension" "vm1" {
  name                       = "vm1"
  location                   = var.location
  resource_group_name        = var.rg_name
  virtual_machine_name       = azurerm_virtual_machine.vm1.name
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "OmsAgentForLinux"
  type_handler_version       = "1.7"
  auto_upgrade_minor_version = true
  depends_on                 = [azurerm_virtual_machine.vm1]

  settings = <<SETTINGS
    {
        "workspaceId": "${var.workspace_id}"
    }
SETTINGS


  protected_settings = <<SETTINGS
    {
        "workspaceKey": "${var.workspace_key}"
    }
SETTINGS


  tags = {
    environment = "Production"
  }
}

