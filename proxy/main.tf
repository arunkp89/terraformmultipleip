// Must already have a storage account set up and keys configured for terraform state.
//export ARM_ACCESS_KEY=$(az storage account keys list --resource-group mtagroup --account-name mtateststorage --query [0].value -o tsv)

terraform {
  backend "azurerm" {
    resource_group_name = "mtagroup"

    storage_account_name = "mtateststorage"
    container_name       = "mta-terraform-state"

    // proxy/{{.Name}}/tf.tfstate
    key = "proxy/proxy1/tf.tfstate"
  }
}

provider "azurerm" {
  version = "~> 1.37"
}

// Define the basics for a working test resource-group/container-registry/service principal/cluster/node pool
variable "prefix" {
  default = "pbaz"
}

variable "env" {
  default = "dev"
}

variable "location" {
}

variable "name" {
  default = "proxytest"
}

variable "rg_name" {
}

variable "custom_image_name" {
  default = "go-mmproxy-centos"
}

variable "network_name" {
}

variable "subnet_proxies_name" {
}

variable "workspace_id" {
}

variable "workspace_key" {
}

data "azurerm_subnet" "subnet" {
  virtual_network_name = var.network_name
  name                 = var.subnet_proxies_name
  resource_group_name  = var.rg_name
}

