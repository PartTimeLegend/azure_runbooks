resource "azurerm_automation_account" "automation_account" {
  name                = "${var.automation_account_name}-${local.az_region_abbrv}"
  location            = azurerm_resource_group.rgautomation.location
  resource_group_name = azurerm_resource_group.rgautomation.name
  sku_name            = "Basic"
  depends_on = [
    azurerm_resource_group.rgautomation
  ]
}

resource "azurerm_automation_module" "az_accounts" {
  name                    = "Az.Accounts"
  resource_group_name     = azurerm_resource_group.rgautomation.name
  automation_account_name = azurerm_automation_account.automation_account.name

  module_link {
    uri = "https://psg-prod-eastus.azureedge.net/packages/az.accounts.2.3.0.nupkg"
  }
  depends_on = [
    azurerm_resource_group.rgautomation,
    azurerm_automation_account.automation_account
  ]
}

resource "azurerm_automation_module" "az_resources" {
  name                    = "Az.Resources"
  resource_group_name     = azurerm_resource_group.rgautomation.name
  automation_account_name = azurerm_automation_account.automation_account.name

  module_link {
    uri = "https://psg-prod-eastus.azureedge.net/packages/az.resources.4.1.1.nupkg"
  }
  depends_on = [
    azurerm_resource_group.rgautomation,
    azurerm_automation_account.automation_account,
    azurerm_automation_module.az_accounts
  ]
}
