resource "azurerm_public_ip" "ip1" {
  name                = "ip1"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  domain_name_label   = "ip1"
  reverse_fqdn        = "ip1.eastus2.cloudapp.azure.com"
  sku                 = "standard"
  //  tags = {
  //  }
}

resource "azurerm_public_ip" "ip2" {
  name                = "ip2"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  domain_name_label   = "ip2"
  reverse_fqdn        = "ip2.eastus2.cloudapp.azure.com"
  sku                 = "standard"
  //  tags = {
  //  }
}

resource "azurerm_public_ip" "ip3" {
  name                = "ip3"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  domain_name_label   = "ip3"
  reverse_fqdn        = "ip3.eastus2.cloudapp.azure.com"
  sku                 = "standard"
  //  tags = {
  //  }
}

resource "azurerm_public_ip" "ip4" {
  name                = "ip4"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  domain_name_label   = "ip4"
  reverse_fqdn        = "ip4.eastus2.cloudapp.azure.com"
  sku                 = "standard"
  //  tags = {
  //  }
}

resource "azurerm_public_ip" "ip5" {
  name                = "ip5"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  domain_name_label   = "ip5"
  reverse_fqdn        = "ip5.eastus2.cloudapp.azure.com"
  sku                 = "standard"
  //  tags = {
  //  }
}

resource "azurerm_public_ip" "ip6" {
  name                = "ip6"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  domain_name_label   = "ip6"
  reverse_fqdn        = "ip6.eastus2.cloudapp.azure.com"
  sku                 = "standard"
  //  tags = {
  //  }
}

