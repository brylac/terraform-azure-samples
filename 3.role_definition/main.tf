provider "azurerm" {
  version = "=2.0.0"
  features {}
}

#create a resource group
resource "azurerm_resource_group" "rg" {
  name = "${var.prefix}-rg"
  location = var.location
}