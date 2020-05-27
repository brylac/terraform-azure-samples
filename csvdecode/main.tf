provider "azurerm" {
  version = "=2.10.0"
  features {}
}

#create a resource group
resource "azurerm_resource_group" "rg" {
  name = "${var.prefix}-rg"
  location = var.location
}

locals {
  csvdata = file("${path.module}/environment_build.csv")
  instances = csvdecode(local.csvdata)
}

resource "azurerm_virtual_network" "vnet1" {
  name = "vnet1"
  address_space = var.addressspace
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "sub1" {
  name = "primarysub"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes = var.addressprefix1 
}

#create a nic for each of the virtual machines in the CSV
resource "azurerm_network_interface" "nic" {
  for_each = { for inst in local.instances : inst.server-name => inst}
  name = each.value.nic-name
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.sub1.id
    private_ip_address_allocation = each.value.ip1-allocation
    private_ip_address = each.value.ip1
  }
}

#random string for admin password
resource "random_string" "pw" {
  length = 16
  special = true
}

resource "azurerm_windows_virtual_machine" "winvm" {
  for_each = { for inst in local.instances : inst.server-name => inst}

  name = each.value.server-name
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  size = each.value.vm-size
  admin_username = "superman"
  admin_password = "${random_string.pw.result}"

#beacuse each nic has a "for_each" set - it's attributes must be accessed by specific instances
#i.e. azurerm_network_interface[each.key].id
  network_interface_ids = [
    azurerm_network_interface.nic[each.value.server-name].id
  ]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = each.value.publisher
    offer = each.value.offer
    sku = each.value.sku
    version = each.value.version
  }
}

output "adminpw" {
  description = "The password for the admin user"
  value = "${random_string.pw.result}"
}