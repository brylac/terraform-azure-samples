provider "azurerm" {
  version = "=2.0.0"
  features {}
}

#create a resource group
resource "azurerm_resource_group" "rg" {
  name = "MyResourceGroup-Main"
  location = var.location
}

terraform {
  backend "azurerm" {
    resource_group_name = "MyResourceGroup-RemoteState"
    storage_account_name = "MyStorageAccountRemoteState"
    container_name       = "RemoteState-Container"
    key                  = "MyRemote-State"
  }
}