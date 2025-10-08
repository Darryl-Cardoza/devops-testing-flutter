# Contains all resource definitions for Microsoft Azure.

resource "azurerm_resource_group" "main" {
  count    = var.enable_azure ? 1 : 0
  name     = var.azure_resource_group_name
  location = var.azure_location
}

resource "azurerm_storage_account" "artifact_storage" {
  count                    = var.enable_azure ? 1 : 0
  name                     = "${replace(var.project_name, "-", "")}artifacts${random_pet.suffix.id}"
  resource_group_name      = azurerm_resource_group.main[0].name
  location                 = azurerm_resource_group.main[0].location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Locally-redundant storage

  tags = {
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Version     = var.app_version
  }
}

resource "azurerm_storage_container" "artifacts" {
  count                 = var.enable_azure ? 1 : 0
  name                  = "releases"
  storage_account_name  = azurerm_storage_account.artifact_storage[0].name
  container_access_type = "private"
}
