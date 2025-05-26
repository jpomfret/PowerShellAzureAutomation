resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_automation_account" "example" {
  name                = var.automation_account_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "Basic"
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}