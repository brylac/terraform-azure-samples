#create a custom role definition to access to the blob
data "azurerm_subscription" "primary" {

}
resource "azurerm_role_definition" "blobrw" {
  name = "access-to-azure-blob"
  scope = data.azurerm_subscription.primary.id
  description = "This is a sample custom role created via Terraform"

  permissions {
    actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/read",
    ]
    data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
    ]
    not_actions = []
    not_data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete",
    ]
  }
  assignable_scopes = [
    "${data.azurerm_subscription.primary.id}"
  ]
}

resource "azurerm_role_assignment" "blobrw_assignment" {
  scope = data.azurerm_subscription.primary.id
  role_definition_id = azurerm_role_definition.blobrw.id
  principal_id = azurerm_linux_virtual_machine.linuxvm.identity.0.principal_id
}
