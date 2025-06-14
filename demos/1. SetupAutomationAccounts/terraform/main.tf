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

resource "azurerm_automation_runbook" "example" {
  name                    = "AzureCleanUpRunbook"
  location                = azurerm_automation_account.example.location
  resource_group_name     = azurerm_resource_group.example.name
  automation_account_name = azurerm_automation_account.example.name
  log_verbose             = false
  log_progress            = false
  runbook_type            = "PowerShell72"
  content                 = file("C:\\GitHub\\PowerShellAzureAutomation\\demos\\2. AzureCleanUpRunbook\\1. basic.ps1")
  tags                    = var.tags
  depends_on = [
    azurerm_automation_account.example
  ]
}