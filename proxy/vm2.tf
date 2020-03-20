resource "azurerm_network_interface" "vm2" {
  name                          = "${local.my_fullprefix}-${var.name}-nic2"
  location                      = var.location
  resource_group_name           = var.rg_name
  enable_ip_forwarding          = true
  network_security_group_id     = azurerm_network_security_group.main.id
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ip4"
    subnet_id                     = data.azurerm_subnet.subnet.id
    primary                       = true
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.64.7"
    public_ip_address_id          = azurerm_public_ip.ip4.id
  }

  ip_configuration {
    name                          = "ip5"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.64.8"
    public_ip_address_id          = azurerm_public_ip.ip5.id
  }

  ip_configuration {
    name                          = "ip6"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.64.9"
    public_ip_address_id          = azurerm_public_ip.ip6.id
  }
}

resource "azurerm_virtual_machine" "vm2" {
  name                  = "${local.my_fullprefix}-${var.name}-2"
  zones                 = [2]
  location              = var.location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.vm2.id]
  vm_size               = "Standard_F16"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = data.azurerm_image.mmproxy.id
  }

  storage_os_disk {
    name              = "${local.my_fullprefix}-${var.name}-disk-2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.my_fullprefix}-${var.name}-2"
    admin_username = "testadmin"

    custom_data = <<CLOUDINIT
    #cloud-config
    package_update: true
    package_upgrade: true
    package_reboot_if_required: true
    CLOUDINIT

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

resource "azurerm_virtual_machine_extension" "vm2" {
  name                       = "vm2"
  location                   = var.location
  resource_group_name        = var.rg_name
  virtual_machine_name       = azurerm_virtual_machine.vm2.name
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "OmsAgentForLinux"
  type_handler_version       = "1.7"
  auto_upgrade_minor_version = true

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

