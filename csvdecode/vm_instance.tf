locals {
  csvdata = file("${path.module}/environment_build.csv")
  instances = csvdecode(local.csvdata)
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