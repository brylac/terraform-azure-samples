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